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

    for i2 in axes(di, 1)

        di[i1, i2] = di[i2, i1] = i1 == i2 ? 0.0 : Omics.Distance.Polar()(an_[i2], an)

    end

end

function get_polar!(
    d1;
    ui = 2000,
    st = P2 * 0.1,
    # TODO: Try # Min(P(Accepting the best case, -1 to 1)) = 0.5.
    te = 2.0 / log(2.0), # Max(P(Accepting the worst case, 1 to -1)) = 0.5.
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

        ac_[1] = true

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

        pr = exp((c2 - c1) / te)

        ac = rand() < pr

        if ac

            an_[ir] = ra

            c1 = c2

        else

            _update!(d2, an_, ir, an_[ir])

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
                "y" => clamp!(pr_, 0, 1),
                "mode" => "markers",
                "marker" => Dict("size" => 2, "color" => Omics.Color.BL),
            ),
            Dict(
                "legendgroup" => "Correlation",
                "name" => "All",
                "mode" => "markers",
                "y" => co_,
                "marker" => Dict(
                    "size" => map(ac -> ac ? 8 : 4, ac_),
                    "color" => map(ac -> ac ? Omics.Color.GR : "#000000", ac_),
                ),
            ),
            Dict(
                "legendgroup" => "Correlation",
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
            "yaxis" => Dict("tickvals" => (0, 0.5, 1)),
            "xaxis" => Dict("title" => Dict("text" => "Time")),
        ),
    )

end

end
