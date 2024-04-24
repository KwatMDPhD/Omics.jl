module Radar

using Distances: Euclidean, Metric, pairwise

using Distributions: Normal

using Statistics: cor

using ..Nucleus

struct Di <: Metric end

function (::Di)(a1, a2)

    di = Euclidean()(a1, a2)

    if pi < di

        di = pi - rem(di, pi)

    end

    di

end

function _update!(A, an_, iu, up)

    for id in eachindex(an_)

        A[id, iu] = A[iu, id] = Di()(an_[id], up)

    end

end

function anneal(D; ma = 1000, st = 0.5 * pi, te = 2 / log(2), de = 1)

    sl = 2 * pi / size(D, 2)

    an_ = [sl * (id - 1) for id in axes(D, 2)]

    A = pairwise(Di(), an_)

    D_ = vec(D)#[D[id] for id in eachindex(D)]

    A_ = vec(A)#[A[id] for id in eachindex(A)]

    ob = cor(D_, A_)

    ob_ = Vector{Float64}(undef, 1 + ma)

    te_ = Vector{Float64}(undef, 1 + ma)

    ac_ = BitVector(undef, 1 + ma)

    ob_[1] = ob

    te_[1] = te

    ac_[1] = true

    for ui in 1:ma

        iu = rand(eachindex(an_))

        up = rand(Normal(an_[iu], st))

        if 2 * pi < abs(up)

            up = rem(up, 2 * pi)

        end

        if up < 0

            up += 2 * pi

        end

        _update!(A, an_, iu, up)

        ou = cor(D_, copyto!(A_, A))

        te *= (1 - ui / ma)^de

        ac = rand() < exp((ou - ob) / te)

        if ac

            an_[iu] = up

            ob = ou

        else

            _update!(A, an_, iu, an_[iu])

        end

        ob_[1 + ui] = ou

        te_[1 + ui] = te

        ac_[1 + ui] = ac

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

function convert_cartesian_to_polar(xc, yc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2 * pi

    end

    an, sqrt(xc^2 + yc^2)

end

function convert_cartesian_to_polar(C)

    P = similar(C)

    for id in axes(P, 2)

        P[1, id], P[2, id] = convert_cartesian_to_polar(C[2, id], C[1, id])

    end

    P

end

function convert_polar_to_cartesian(an, ra)

    si, co = sincos(an)

    co * ra, si * ra

end

function convert_polar_to_cartesian(P)

    C = similar(P)

    for id in axes(C, 2)

        C[2, id], C[1, id] = convert_polar_to_cartesian(P[1, id], P[2, id])

    end

    C

end

end
