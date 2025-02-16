module PolarCoordinate

using Distances: pairwise

using Distributions: Normal

using Statistics: cor

using ..Omics

const _P2 = 2.0 * pi

function _update!(di, a1_, i2, a2)

    for i1 in eachindex(a1_)

        di[i1, i2] = di[i2, i1] = i1 == i2 ? 0.0 : Omics.Distance.Polar()(a1_[i1], a2)

    end

end

function ge!(
    d1;
    u1 = 1000,
    st = _P2 * 0.1,
    lo = 0.32,
    sc = 32.0,
    co_ = nothing,
    te_ = nothing,
    pr_ = nothing,
    ac_ = nothing,
)

    u2 = size(d1, 1)

    a1_ = collect(range(0.0; step = _P2 / u2, length = u2))

    d2 = pairwise(Omics.Distance.Polar(), a1_)

    d1_ = vec(d1)

    d2_ = vec(d2)

    c1 = cor(d1_, d2_)

    for i1 in 1:u1

        i2 = rand(1:u2)

        a1 = a1_[i2]

        a2 = rand(Normal(a1, st))

        if _P2 < abs(a2)

            a2 = rem(a2, _P2)

        end

        if a2 < 0.0

            a2 += _P2

        end

        _update!(d2, a1_, i2, a2)

        c2 = cor(d1_, d2_)

        te = 1.0 - Omics.Probability.get_logistic((i1 - u1 * lo) / u1 * sc)

        if c1 <= c2

            pr = 1.0

            ac = true

        else

            pr = exp((c2 - c1) / te)

            ac = rand() < pr

        end

        if ac

            a1_[i2] = a2

            c1 = c2

        else

            _update!(d2, a1_, i2, a1)

        end

        if !isnothing(co_)

            co_[i1] = c2

            te_[i1] = te

            pr_[i1] = pr

            ac_[i1] = ac

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
                    "color" => map(ac -> ac ? Omics.Color.GR : Omics.Color.S2, ac_),
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
        Dict("xaxis" => Dict("title" => Dict("text" => "Iteration"))),
    )

end

end
