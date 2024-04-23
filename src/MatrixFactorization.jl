module MatrixFactorization

using LinearAlgebra: mul!, norm

using NMF: nnmf

using NonNegLeastSquares: nonneg_lsq

using StatsBase: mean, sqL2dist

using ..Nucleus

function factorize(A, uf; ke_ar...)

    re = nnmf(A, uf; ke_ar...)

    if re.converged

        @info "Converged with $(re.niters) iterations." re.objvalue

    else

        @warn "Failed to converged with $(re.niters) iterations." re.objvalue

    end

    re.W, re.H

end

function _initialize(u1, u2, A, uf)

    rand(u1, u2) .*= sqrt(mean(A) / uf)

end

function _initialize(A, uf::Integer)

    #_initialize(size(A, 1), uf, A, uf)

    W = rand(size(A, 1), uf)

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(W))

    W

end

function _initialize(uf::Integer, A)

    #_initialize(uf, size(A, 2), A, uf)

    rand(uf, size(A, 2))

end

function _get_objective(A, WH)

    ob = 0.5 * sqL2dist(A, WH)

    @info ob

    ob

end

# TODO: Match with `nnmf`.
function factorize_wide(A_, uf; to = 0.01, ui = 100, we_ = ones(lastindex(A_)))

    ua = lastindex(A_)

    ia_ = 1:ua

    u1 = size(A_[1], 1)

    u2_ = (size(A, 2) for A in A_)

    W = _initialize(A_[1], uf)

    H_ = [_initialize(uf, A) for A in A_]

    WH_ = [W * H for H in H_]

    AHt_ = [Matrix{Float64}(undef, u1, uf) for _ in A_]

    WHHt_ = [Matrix{Float64}(undef, u1, uf) for _ in A_]

    WtA_ = [Matrix{Float64}(undef, uf, u2) for u2 in u2_]

    WtWH_ = [Matrix{Float64}(undef, uf, u2) for u2 in u2_]

    n1 = norm(A_[1])

    co_ = [n1 / norm(A_[ia]) * we_[ia] for ia in ia_]

    ep = sqrt(eps())

    ob_ = _get_objective.(A_, WH_)

    for ii in 2:ui

        for ia in ia_

            Ht = transpose(H_[ia])

            mul!(AHt_[ia], A_[ia], Ht)

            mul!(WHHt_[ia], WH_[ia], Ht)

        end

        for iw in eachindex(W)

            su = 0

            for ia in ia_

                su += co_[ia] * AHt_[ia][iw] / (WHHt_[ia][iw] + ep)

            end

            W[iw] *= su / ua

        end

        Wt = transpose(W)

        for ia in ia_

            H = H_[ia]

            WtA = WtA_[ia]

            WtWH = WtWH_[ia]

            mul!(WtA, Wt, A_[ia])

            mul!(WtWH, Wt, WH_[ia])

            co = co_[ia]

            for ih in eachindex(H)

                H[ih] *= co * WtA[ih] / (WtWH[ih] + ep)

            end

        end

        for ia in ia_

            mul!(WH_[ia], W, H_[ia])

        end

        ob_ .= _get_objective.(A_, WH_)

        if all(<(to), ob_)

            @info "Converged with $ii iterations." ob_

            break

        elseif ii == ui

            @warn "Failed to converged with $ii iterations." ob_

        end

    end

    W, H_

end

function solve_h(W, A)

    AWi = Matrix{Float64}(undef, size(W, 2), size(A, 2))

    for (i2, nu_) in enumerate(eachcol(A))

        AWi[:, i2] = nonneg_lsq(W, nu_; alg = :nnls)

    end

    AWi

end

end
