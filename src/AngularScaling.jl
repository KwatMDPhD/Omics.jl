module AngularScaling

using Distances: pairwise!

using Distributions: Normal

using Statistics: cor

using ..Nucleus

function plot(ht, an_)

    Nucleus.Plot.plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "theta" => an_ / pi * 180,
                "r" => ones(lastindex(an_)),
                "text" => eachindex(an_),
                "mode" => "markers+text",
                "marker" => Dict("size" => 40, "color" => "#ffff00"),
                "subplot" => "polar3",
            ),
            Dict("x" => [1, 2], "y" => [1, 2], "subplot" => "polar3"),
        ],
        Dict("polar" => Dict("angularaxis" => Dict(), "radialaxis" => Dict())),
    )

end

function _get_objective(D, A)

    sc = 0

    for id in axes(D, 2)

        sc += cor(view(D, :, id), view(A, :, id))

    end

    sc / size(D, 2)

end


function scale(D, t0, st, ma; pl = false)

    sl = 2 * pi / size(D, 2)

    co_ = [sl * (id - 1) for id in axes(D, 2)]

    if pl

        plot(joinpath(Nucleus.TE, "0.html"), co_)

    end

    A = similar(D)

    ui = 0

    while ui < ma

        ui += 1

        pairwise!(Nucleus.Distance.AngularDistanceNorm(), A, co_)

        be = _get_objective(D, A)

        ir = rand(eachindex(co_))

        cr = rand(Normal(co_[ir], st))

        for ic in eachindex(co_)

            A[ir, ic] = A[ic, ir] = Nucleus.Distance.AngularDistanceNorm()(co_[ic], cr)

        end

        af = _get_objective(D, A)

        te = t0 * (1 - ui / ma)

        pr = exp((af - be) / te)

        mo = rand() < pr

        if mo

            co_[ir] = cr

            if pl

                plot(joinpath(Nucleus.TE, "$ui.html"), co_)

            end

        end

    end

    co_

end

end
