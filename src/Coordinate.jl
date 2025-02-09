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

function _update!(di, a1_, i2, a2)

    for i1 in axes(di, 1)

        di[i1, i2] = di[i2, i1] = i1 == i2 ? 0.0 : Omics.Distance.Polar()(a1_[i1], a2)

    end

end

function get_polar!(
    d1;
    ui = 1000,
    st = P2 * 0.1,
    lo = 0.32,
    sc = 32.0,
    co_ = nothing,
    te_ = nothing,
    pr_ = nothing,
    ac_ = nothing,
)

    ua = size(d1, 1)

    a1_ = collect(range(0.0; step = P2 / ua, length = ua))

    d2 = pairwise(Omics.Distance.Polar(), a1_)

    d1_ = vec(d1)

    d2_ = vec(d2)

    c1 = cor(d1_, d2_)

    if !isnothing(co_)

        co_[1] = c1

        te_[1] = NaN

        pr_[1] = NaN

        ac_[1] = true

    end

    for ii in 1:ui

        ir = rand(1:ua)

        a1 = a1_[ir]

        a2 = rand(Normal(a1, st))

        if P2 < abs(a2)

            a2 = rem(a2, P2)

        end

        if a2 < 0.0

            a2 += P2

        end

        _update!(d2, a1_, ir, a2)

        c2 = cor(d1_, d2_)

        te = 1.0 / (1.0 + exp((ii - ui * lo) / ui * sc))

        if c1 <= c2

            pr = 1.0

            ac = true

        else

            pr = exp((c2 - c1) / te)

            ac = rand() < pr

        end

        if ac

            a1_[ir] = a2

            c1 = c2

        else

            _update!(d2, a1_, ir, a1)

        end

        if !isnothing(co_)

            it = 1 + ii

            co_[it] = c2

            te_[it] = te

            pr_[it] = pr

            ac_[it] = ac

        end

    end

    a1_

end

function plot(ht, co_, te_, pr_, ac_)

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
                "name" => "Probability",
                "y" => pr_,
                "mode" => "markers",
                "marker" => Dict("size" => 2, "color" => Omics.Color.BL),
            ),
            Dict(
                "name" => "Correlation",
                "y" => co_,
                "mode" => "markers",
                "marker" => Dict(
                    "size" => map(ac -> ac ? 8 : 4, ac_),
                    "color" => map(ac -> ac ? Omics.Color.GR : Omics.Color.SG, ac_),
                ),
            ),
            Dict(
                "name" => "Maximum",
                "y" => (ma,),
                "x" => (id - 1,),
                "text" => Omics.Numbe.shorten(ma),
                "mode" => "markers+text",
                "marker" => Dict("size" => 24, "color" => Omics.Color.GR),
            ),
        ),
        Dict(
            "yaxis" => Dict("zeroline" => false),
            "xaxis" => Dict("title" => Dict("text" => "Time")),
        ),
    )

end

end
