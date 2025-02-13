module MatrixFactorization

using LinearAlgebra: mul!, norm

using NMF: nnmf

using NonNegLeastSquares: nonneg_lsq

using StatsBase: mean, sqL2dist

using ..Omics

function _lo(co, nu, ob)

    if co

        @info "Converged in $nu." ob

    else

        @warn "Failed to converge in $nu." ob

    end

end

function factorize(A, nu; ke_ar...)

    re = nnmf(A, nu; ke_ar...)

    _lo(re.converged, re.niters, re.objvalue / lastindex(A))

    re.W, re.H

end

function _get_coefficient(A_)

    nu = lastindex(A_)

    co_ = Vector{Float64}(undef, nu)

    no = norm(A_[1])

    co_[1] = 1.0

    for id in 2:nu

        co_[id] = no / norm(A_[id])

    end

    co_

end

function _initialize(A, nu::Integer)

    W = rand(size(A, 1), nu)

    foreach(Omics.Normalization.normalize_with_sum!, eachcol(W))

    fa = sqrt(mean(A) / nu * lastindex(A))

    map!(nu -> nu * fa, W, W)

end

function _initialize(nu::Integer, A)

    H = rand(nu, size(A, 2))

    foreach(Omics.Normalization.normalize_with_sum!, eachrow(H))

    fa = sqrt(mean(A) / nu * lastindex(A))

    map!(nu -> nu * fa, H, H)

end

function _get_objective(A, WH)

    0.5 * sqL2dist(A, WH)

end

function factorize_wide(
    A_,
    u1;
    to = 0.01,
    u2 = 100,
    W = _initialize(A_[1], u1),
    H_ = [_initialize(u1, A) for A in A_],
    co_ = _get_coefficient(A_),
)

    WH_ = map(H -> W * H, H_)

    ob_ = map(_get_objective, A_, WH_)

    Wp = Matrix{Float64}(undef, size(W))

    Hp_ = [Matrix{Float64}(undef, size(H)) for H in H_]

    AHt_ = [Matrix{Float64}(undef, size(A_[1], 1), u1) for _ in A_]

    WHHt_ = [Matrix{Float64}(undef, size(A_[1], 1), u1) for _ in A_]

    WtA_ = [Matrix{Float64}(undef, u1, size(A, 2)) for A in A_]

    WtWH_ = [Matrix{Float64}(undef, u1, size(A, 2)) for A in A_]

    bo = false

    ep = sqrt(eps())

    u3 = 0

    while !bo && u3 < u2

        u3 += 1

        copyto!(Wp, W)

        for ia in eachindex(A_)

            copyto!(Hp_[ia], H_[ia])

        end

        for ia in eachindex(A_)

            Ht = transpose(H_[ia])

            mul!(AHt_[ia], A_[ia], Ht)

            mul!(WHHt_[ia], WH_[ia], Ht)

        end

        for iw in eachindex(W)

            nu = de = 0

            for ia in eachindex(A_)

                nu += co_[ia] * AHt_[ia][iw]

                de += co_[ia] * WHHt_[ia][iw]

            end

            W[iw] *= nu / (de + ep)

        end

        for ia in eachindex(A_)

            mul!(WH_[ia], W, H_[ia])

        end

        Wt = transpose(W)

        for ia in eachindex(A_)

            mul!(WtA_[ia], Wt, A_[ia])

            mul!(WtWH_[ia], Wt, WH_[ia])

            for ih in eachindex(H_[ia])

                H_[ia][ih] *= WtA_[ia][ih] / (WtWH_[ia][ih] + ep)

            end

            mul!(WH_[ia], W, H_[ia])

        end

        ob_ .= _get_objective.(A_, WH_)

        bo = all(_has_converged(W, Wp, H_[ia], Hp_[ia], to) for ia in eachindex(A_))

    end

    _lo(bo, u3, ob_ ./ lastindex.(A_))

    W, H_

end

function _has_converged(W, Wp, H, Hp, to)

    for ic in axes(W, 2)

        wd = ws = hd = hs = 0

        for i1 in axes(W, 1)

            wd += (W[i1, ic] - Wp[i1, ic])^2

            ws += (W[i1, ic] + Wp[i1, ic])^2

        end

        for i2 in axes(H, 2)

            hd += (H[ic, i2] - Hp[ic, i2])^2

            hs += (H[ic, i2] + Hp[ic, i2])^2

        end

        if to * sqrt(ws) < sqrt(wd) || to * sqrt(hs) < sqrt(hd)

            return false

        end

    end

    true

end

function solve_h(W, A)

    AWi = Matrix{Float64}(undef, size(W, 2), size(A, 2))

    for i2 in axes(A, 2)

        AWi[:, i2] = nonneg_lsq(W, view(A, :, i2); alg = :nnls)

    end

    AWi

end

end
