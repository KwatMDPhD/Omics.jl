module Radar

using Distances: pairwise

using Distributions: Normal

using Statistics: cor

using ..Nucleus

function _update!(A, an_, iu, up)

    for id in eachindex(an_)

        A[id, iu] = A[iu, id] = Nucleus.Distance.AngularDistance2()(an_[id], up)

    end

end

function anneal(D; ma = 1000, st = 0.5 * pi, te = 2 / log(2), de = 1)

    sl = 2 * pi / size(D, 2)

    an_ = [sl * (id - 1) for id in axes(D, 2)]

    A = pairwise(Nucleus.Distance.AngularDistance2(), an_)

    D_ = vec(D)#[D[id] for id in eachindex(D)]

    A_ = vec(A)#[A[id] for id in eachindex(A)]

    ob = cor(D_, A_)

    ob_ = Vector{Float64}(undef, 1 + ma)

    te_ = similar(ob_)

    ac_ = BitVector(undef, 1 + ma)

    ob_[1] = ob

    te_[1] = te

    ac_[1] = 1

    for ui in 1:ma

        iu = rand(eachindex(an_))

        up = rand(Normal(an_[iu], st))

        _update!(A, an_, iu, up)

        ou = cor(D_, copyto!(A_, A))

        ob_[1 + ui] = ou

        te *= (1 - ui / ma)^de

        te_[1 + ui] = te

        ac = rand() < exp((ou - ob) / te)

        ac_[1 + ui] = ac

        if ac

            an_[iu] = up

            ob = ou

        else

            _update!(A, an_, iu, an_[iu])

        end

    end

    an_, ob_, te_, ac_

end

function plot_annealing(ht, ob_, te_, ac_)

    Nucleus.Plot.plot(
        ht,
        [
            Dict(
                "name" => "Objective",
                "y" => ob_,
                "mode" => "markers",
                "line" => Dict("color" => "#000000"),
                "marker" => Dict(
                    "size" => [ac ? 8 : 2 for ac in ac_],
                    "color" => [ac ? "#00ff00" : "#000000" for ac in ac_],
                ),
            ),
            Dict("name" => "Temperature", "y" => te_, "marker" => Dict("color" => "#ff0000")),
        ],
    )

end

function plot_radar(ht, an_)

    Nucleus.Plot.plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "theta" => an_ / pi * 180,
                "r" => ones(lastindex(an_)),
                "text" => eachindex(an_),
                "mode" => "markers+text",
                "marker" => Dict("size" => 48, "color" => "#ffff00"),
            ),
        ],
        Dict(
            "polar" => Dict(
                "angularaxis" =>
                    Dict("showgrid" => false, "ticks" => "", "showticklabels" => false),
                "radialaxis" => Dict(
                    "showline" => false,
                    "showgrid" => false,
                    "ticks" => "",
                    "showticklabels" => false,
                ),
            ),
        ),
    )

end

end
