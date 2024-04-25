module Coordinate

using Distances: Metric, pairwise

using Distributions: Normal

using MultivariateStats: MetricMDS, fit

using Statistics: cor

using ..Nucleus

function get_cartesian(aa)

    fit(MetricMDS, aa; distances = true, maxoutdim = 2, maxiter = 1000).X

end

struct PolarDistance <: Metric end

function (::PolarDistance)(a1, a2)

    di = abs(a1 - a2)

    if pi < di

        di = 2 * pi - di

    end

    di

end

function _update!(cc, cu_, iu, up)

    for id in axes(cc, 2)

        cc[iu, id] = cc[id, iu] = id == iu ? 0 : PolarDistance()(cu_[id], up)

    end

end

function get_polar(aa; ma = 1000, st = 0.5 * pi, te = 2 / log(2), de = 1, pl = false)

    cu_ = collect(range(0; step = 2 * pi / size(aa, 2), length = size(aa, 2)))

    cc = pairwise(PolarDistance(), cu_)

    aa_ = vec(aa)

    cc_ = vec(cc)

    sc = cor(aa_, cc_)

    if pl

        sc_ = Vector{Float64}(undef, 1 + ma)

        te_ = Vector{Float64}(undef, 1 + ma)

        go_ = BitVector(undef, 1 + ma)

        sc_[1] = sc

        te_[1] = te

        go_[1] = true

    end

    for ui in 1:ma

        iu = rand(eachindex(cu_))

        up = rand(Normal(cu_[iu], st))

        if 2 * pi < abs(up)

            up = rem(up, 2 * pi)

        end

        if up < 0

            up += 2 * pi

        end

        _update!(cc, cu_, iu, up)

        ne = cor(aa_, cc_)

        te *= (1 - ui / ma)^de

        go = rand() < exp((ne - sc) / te)

        if go

            cu_[iu] = up

            sc = ne

        else

            _update!(cc, cu_, iu, cu_[iu])

        end

        if pl

            sc_[1 + ui] = ne

            te_[1 + ui] = te

            go_[1 + ui] = go

        end

    end

    if pl

        Nucleus.Plot.plot(
            "",
            [
                Dict(
                    "name" => "Score",
                    "y" => sc_,
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

    cu_

end

function make_unit(an_)

    pa = Matrix{Float64}(undef, 2, lastindex(an_))

    pa[1, :] = an_

    pa[2, :] .= 1

    pa

end

function convert_cartesian_to_polar(xc, yc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2 * pi

    end

    an, sqrt(xc^2 + yc^2)

end

function convert_polar_to_cartesian(an, ra)

    si, co = sincos(an)

    co * ra, si * ra

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

        xc, yc = convert_polar_to_cartesian(pa[1, id], pa[2, id])

        ca[1, id] = xc

        ca[2, id] = yc

    end

    ca

end

end
