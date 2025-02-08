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

function _update!(di, an_, i1, an)

    fu = Omics.Distance.Polar()

    for i2 in axes(di, 1)

        di[i1, i2] = di[i2, i1] = i1 == i2 ? 0.0 : fu(an_[i2], an)

    end

end

function get_polar!(
    d1;
    ui = 2000,
    st = P2 * 0.1,
    te = 2.0 / log(2.0), # Max(P(Accepting 1 to -1)) = 0.5. TODO: Try # Min(P(Accepting -1 to 1)) = 0.5.
    de = 0.01,
    co_ = nothing,
    te_ = nothing,
    pr_ = nothing,
    ac_ = nothing,
)

    up = size(d1, 1)

    an_ = collect(range(0.0; step = P2 / up, length = up))

    d2 = pairwise(Omics.Distance.Polar(), an_)

    d1_ = vec(d1)

    d2_ = vec(d2)

    c1 = cor(d1_, d2_)

    if !isnothing(co_)

        co_[1] = c1

        te_[1] = te

        pr_[1] = 1.0

        ac_[1] = true

    end

    for id in 1:ui

        ir = rand(1:up)

        a1 = an_[ir]

        a2 = rand(Normal(a1, st))

        if P2 < abs(a2)

            a2 = rem(a2, P2)

        end

        if a2 < 0.0

            a2 += P2

        end

        _update!(d2, an_, ir, a2)

        c2 = cor(d1_, d2_)

        te *= (1.0 - id / ui)^de

        pr = exp((c2 - c1) / te)

        ac = rand() < pr

        if ac

            an_[ir] = a2

            c1 = c2

        else

            _update!(d2, an_, ir, a1)

        end

        if !isnothing(co_)

            it = 1 + id

            co_[it] = c2

            te_[it] = te

            pr_[it] = pr

            ac_[it] = ac

        end

    end

    an_

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
                    "color" => map(ac -> ac ? Omics.Color.GR : "#000000", ac_),
                ),
            ),
            Dict(
                "name" => "Maximum",
                "y" => (ma,),
                "x" => (id - 1,),
                "text" => Omics.Numbe.shorten(ma),
                "mode" => "markers+text",
                "marker" => Dict("size" => 16, "color" => Omics.Color.YE),
            ),
        ),
        Dict(
            "yaxis" => Dict("tickvals" => (0, 0.5, 1)),
            "xaxis" => Dict("title" => Dict("text" => "Time")),
        ),
    )

end

end
