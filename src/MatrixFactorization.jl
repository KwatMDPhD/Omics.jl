module MatrixFactorization

using NMF: nnmf

using LinearAlgebra: norm

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

end

function _initialize_w(ma, uf)

    _initialize(size(ma, 1), uf, ma, uf)

end

function _initialize_h(ma, uf)

    _initialize(uf, size(ma, 2), ma, uf)

end

function _has_converged(no___, to)

    n1_ = no___[end - 1]

    ne_ = no___[end]

    if all((n1_ .- ne_) ./ n1_ .<= to)

        @info "Converged with $(lastindex(no___)) iterations."

        true

    else

        false

    end

end

function _zero!(nu_)

    ep = eps()

    for id in eachindex(nu_)

        if nu_[id] < ep

            nu_[id] = 0

        end

    end

end

function factorize_wide(ma_, uf, to, ui)

    n1 = norm(ma_[1])

    co_ = [n1 / norm(ma) for ma in ma_]

    mw = _initialize_w(ma_[1], uf)

    mh_ = Tuple(_initialize_h(ma, uf) for ma in ma_)

    no___ = [[norm(ma - mw * mh) for (ma, mh) in zip(ma_, mh_)]]

    for _ in 1:ui

        mw .*=
            sum(co * ma * transpose(mh) for (co, ma, mh) in zip(co_, ma_, mh_)) ./
            sum(co * mw * mh * transpose(mh) for (co, mh) in zip(co_, mh_))

        _zero!(mw)

        for (ma, mh) in zip(ma_, mh_)

            mh .*= (transpose(mw) * ma) ./ (transpose(mw) * mw * mh)

            _zero!(mh)

        end

        no_ = [norm(ma - mw * mh) for (ma, mh) in zip(ma_, mh_)]

        push!(no___, no_)

        if _has_converged(no___, to)

            break

        end

    end

    (mw,), mh_, no___

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
