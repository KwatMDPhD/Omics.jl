module Coordinate

using Distances: pairwise

using Distributions: Normal

using MultivariateStats: MetricMDS, fit

using Statistics: cor

using ..Omics

function get_cartesian(di)

    fit(MetricMDS, di; distances = true, maxoutdim = 2, maxiter = 1000).X

end

const P2 = 2.0 * pi

# TODO: Remember.
function _update!(di, an_, i1, an)

    for i2 in axes(di, 1)

        di[i1, i2] = di[i2, i1] = i1 == i2 ? 0.0 : Omics.Distance.Polar()(an_[i2], an)

    end

end

# TODO: Check te.
function get_polar!(d1; ui = 2000, st = P2 * 0.1, te = 2.0 / log(2.0), de = 0.01, co_=nothing, te_=nothing, go_=nothing)

    up = size(d1, 1)

    an_ = collect(range(0.0; step = P2 / up, length = up))

    d2 = pairwise(Omics.Distance.Polar(), an_)

    d1_ = vec(d1)

    d2_ = vec(d2)

    c1 = cor(d1_, d2_)

    if !isnothing(co_)

        co_[1] = c1

        te_[1] = te

        go_[1] = true

    end

    for id in 1:ui

        ir = rand(1:up)

        ra = rand(Normal(an_[ir], st))

        if P2 < abs(ra)

            ra = rem(ra, P2)

        end

        if ra < 0.0

            ra += P2

        end

        _update!(d2, an_, ir, ra)

        c2 = cor(d1_, d2_)

        te *= (1.0 - id / ui)^de

        # TODO: Generalize with logit.
        go = rand() < exp((c2 - c1) / te)

        if go

            an_[ir] = ra

            c1 = c2

        else

            _update!(d2, an_, ir, an_[ir])

        end

        if !isnothing(co_)

            it = 1 + id

            co_[it] = c2

            te_[it] = te

            go_[it] = go

        end

    end

    an_

end

function plot(ht)

    ma, id = findmax(co_)

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "name" => "Temperature",
                "y" => te_,
                "marker" => Dict("color" => Omics.Color.RE),
            ),
            Dict(
                "legendgroup" => "Score",
                "name" => "All",
                "mode" => "markers",
                "y" => co_,
                "marker" => Dict(
                    "size" => [go ? 8 : 4 for go in go_],
                    "color" => [go ? Omics.Color.GR : "#000000" for go in go_],
                ),
            ),
            Dict(
                "legendgroup" => "Score",
                "name" => "Maximum",
                "mode" => "markers+text",
                "x" => (id - 1,),
                "y" => (ma,),
                "text" => Omics.Numbe.shorten(ma),
                "marker" => Dict("size" => 16, "color" => Omics.Color.YE),
            ),
        ),
        Dict(
            "title" => Dict("text" => "Simulated Annealing"),
            "xaxis" => Dict("title" => Dict("text" => "Iteration")),
        ),
    )

end

function make_unit(an_)

    pa = Matrix{Float64}(undef, 2, lastindex(an_))

    pa[1, :] = an_

    pa[2, :] .= 1

    return pa

end

function convert_cartesian_to_polar(xc, yc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2 * pi

    end

    return an, sqrt(xc^2 + yc^2)

end

function convert_polar_to_cartesian(an, ra)

    si, co = sincos(an)

    return co * ra, si * ra

end

function convert_cartesian_to_polar(ca)

    pa = similar(ca)

    for id in axes(pa, 2)

        an, ra = convert_cartesian_to_polar(ca[1, id], ca[2, id])

        pa[1, id] = an

        pa[2, id] = ra

    end

    return pa

end

function convert_polar_to_cartesian(pa)

    ca = similar(pa)

    for id in axes(ca, 2)

        xc, yc = convert_polar_to_cartesian(pa[1, id], pa[2, id])

        ca[1, id] = xc

        ca[2, id] = yc

    end

    return ca

end

end
