module MatrixFactorization

using NMF: nnmf

using LinearAlgebra: mul!, norm

using NonNegLeastSquares: nonneg_lsq

using StatsBase: mean

using ..Nucleus

function factorize(ma, nf; ke_ar...)

    re = nnmf(ma, nf; ke_ar...)

    me = "with $(re.niters) iterations at $(re.objvalue)."

    if re.converged

        @info "Converged $me"

    else

        @warn "Failed to converge $me"

    end

    re.W, re.H

end

function _initialize(ur, uc, ma, uf)

    rand(ur, uc) * sqrt(mean(ma) / uf)

    # TODO: Normalize.

end

function _initialize(ma, uf::Integer)

    _initialize(size(ma, 1), uf, ma, uf)

end

function _initialize(uf::Integer, ma)

    _initialize(uf, size(ma, 2), ma, uf)

end

function _get_error(A_, WH_)

    (norm(A - WH) for (A, WH) in zip(A_, WH_))

end

function _has_converged(ii, er_, to, ui)

    me = "with $ii iterations:\n$(join(er_, '\n'))."

    if all(<(to), er_)

        @info "Converged $me"

        true

    else

        if ii == ui

            @warn "Failed to converge $me"

        end

        false

    end

end

function factorize_wide(A_, uf, to, ui, we_ = ones(lastindex(A_)))

    ia_ = eachindex(A_)

    A1 = A_[1]

    u1 = size(A1, 1)

    u2_ = size.(A_, 2)

    W = _initialize(A1, uf)

    H_ = _initialize.(uf, A_)

    WH_ = Tuple(W * H_[ia] for ia in ia_)

    AHt_ = Tuple(Matrix{Float64}(undef, u1, uf) for _ in ia_)

    WHHt_ = Tuple(Matrix{Float64}(undef, u1, uf) for _ in ia_)

    WtA_ = Tuple(Matrix{Float64}(undef, uf, u2_[ia]) for ia in ia_)

    WtWH_ = Tuple(Matrix{Float64}(undef, uf, u2_[ia]) for ia in ia_)

    n1 = norm(A1)

    co_ = Tuple(n1 / norm(A_[ia]) * we_[ia] for ia in ia_)

    @info "$u1 $uf $u2_" co_

    ai = Matrix{Float64}(undef, lastindex(ia_), ui)

    ai[:, 1] .= _get_error(A_, WH_)

    ep = sqrt(eps())

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

            W[iw] *= su / lastindex(ia_)

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

        ai[:, ii] .= _get_error(A_, WH_)

        if _has_converged(ii, ai[:, ii], to, ui)

            break

        end

    end

    (W,), H_, ai

end

function solve_h(mw, ma)

    mh = Matrix{Float64}(undef, size(mw, 2), size(ma, 2))

    for (i2, co) in enumerate(eachcol(ma))

        mh[:, i2] = nonneg_lsq(mw, co; alg = :nnls)

    end

    mh

end

function write(
    di,
    ma;
    su = "",
    nl = "Label",
    na = "Factor",
    la_ = (i1 -> "$nl $i1").(1:maximum(size(ma))),
    fa_ = (i1 -> "$na $i1").(1:minimum(size(ma))),
    lo = Nucleus.HTML.WI,
    sh = Nucleus.HTML.HE,
)

    nf, dm = findmin(size(ma))

    if isone(dm)

        wh = "H$su"

        nr = na

        nc = nl

        ro_ = fa_

        co_ = la_

        he = sh

        wi = lo

    else

        wh = "W$su"

        nr = nl

        nc = na

        ro_ = la_

        co_ = fa_

        he = lo

        wi = sh

    end

    pr = joinpath(di, "$nf$wh")

    Nucleus.DataFrame.write("$pr.tsv", nr, ro_, co_, ma)

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        ma;
        y = ro_,
        x = co_,
        layout = Dict(
            "title" => Dict("text" => wh),
            "yaxis" => Dict("title" => Dict("text" => "$nr ($(lastindex(ro_)))")),
            "xaxis" => Dict("title" => Dict("text" => "$nc ($(lastindex(co_)))")),
        ),
        he,
        wi,
    )

end

end
