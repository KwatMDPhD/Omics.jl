module Coordinate

using DelaunayTriangulation: get_convex_hull_indices, get_points

using Distances: Metric, pairwise

using Distributions: Normal

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using Statistics: cor

using ..Nucleus

function get_cartesian(aa)

    fit(MetricMDS, aa; distances = true, maxoutdim = 2, maxiter = 1000).X

end

function wall(tr)

    VPolygon(get_points(tr)[get_convex_hull_indices(tr)])

end

function is_in(ca_, vp)

    element(Singleton(ca_)) ∈ vp

end

struct Di <: Metric end

function (::Di)(a1, a2)

    di = abs(a2 - a1)

    if pi < di

        di = 2 * pi - di

    end

    di

end

function _update!(a2, iu, an_, up)

    for id in axes(a2, 2)

        a2[iu, id] = a2[id, iu] = id == iu ? 0 : Di()(an_[id], up)

    end

end

function get_polar(aa; ma = 1000, st = 0.5 * pi, te = 2 / log(2), de = 1, pl = false)

    an_ = collect(range(0; step = 2 * pi / size(aa, 2), length = size(aa, 2)))

    a2 = pairwise(Di(), an_)

    di_ = vec(aa)

    d2_ = vec(a2)

    ob = cor(di_, d2_)

    if pl

        ob_ = Vector{Float64}(undef, 1 + ma)

        te_ = Vector{Float64}(undef, 1 + ma)

        go_ = BitVector(undef, 1 + ma)

        ob_[1] = ob

        te_[1] = te

        go_[1] = true

    end

    for ui in 1:ma

        iu = rand(eachindex(an_))

        up = rand(Normal(an_[iu], st))

        if 2 * pi < abs(up)

            up = rem(up, 2 * pi)

        end

        if up < 0

            up += 2 * pi

        end

        _update!(a2, iu, an_, up)

        ou = cor(di_, d2_)

        te *= (1 - ui / ma)^de

        go = rand() < exp((ou - ob) / te)

        if go

            an_[iu] = up

            ob = ou

        else

            _update!(a2, iu, an_, an_[iu])

        end

        if pl

            ob_[1 + ui] = ou

            te_[1 + ui] = te

            go_[1 + ui] = go

        end

    end

    if pl

        Nucleus.Plot.plot(
            "",
            [
                Dict(
                    "name" => "Objective",
                    "y" => ob_,
                    "mode" => "markers",
                    "line" => Dict("color" => "#000000"),
                    "marker" => Dict(
                        "size" => [go ? 8 : 2 for go in go_],
                        "color" => [go ? Nucleus.Color.HEGR : "#000000" for go in go_],
                    ),
                ),
                Dict(
                    "name" => "Temperature",
                    "y" => te_,
                    "marker" => Dict("color" => Nucleus.Color.HERE),
                ),
            ],
        )

    end

    an_

end

function make_unit(an_)

    pa = Matrix{Float64}(undef, 2, lastindex(an_))

    pa[1, :] = an_

    pa[2, :] .= 1

    pa

end

function convert_cartesian_to_polar(yc, xc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2 * pi

    end

    an, sqrt(yc^2 + xc^2)

end

function convert_polar_to_cartesian(an, ra)

    sincos(an) .* ra

end

function convert_cartesian_to_polar(ca)

    pa = similar(ca)

    for id in axes(pa, 2)

        an, ra = convert_cartesian_to_polar(ca[1, id], ca[2, id])

        pa[1, id] = an

        pa[2, id] = ra

    end

    pa

end

function convert_polar_to_cartesian(pa)

    ca = similar(pa)

    for id in axes(ca, 2)

        y, x = convert_polar_to_cartesian(pa[1, id], pa[2, id])

        ca[1, id] = y

        ca[2, id] = x

    end

    ca

end

end
