module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

function _do_not_normalize(ar...)

    return nothing

end

function plot(
    w_,
    h_;
    fu = _do_not_normalize,
    nar_ = ["Rows $id" for id in eachindex(w_)],
    nac_ = ["Columns $id" for id in eachindex(h_)],
    naf = "Factor",
    ro___ = (["$na $id" for id in 1:size(ma, 1)] for (ma, na) in zip(w_, nar_)),
    co___ = (["$na $id" for id in 1:size(ma, 2)] for (ma, na) in zip(h_, nac_)),
    di = "",
)

    fa_ = ["$naf $id" for id in 1:size(w_[1], 2)]

    lo = 777

    sh = lo / MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (w, ro_, nar)) in enumerate(zip(w_, ro___, nar_))

        if isempty(di)

            ht = ""

        else

            ts = joinpath(di, "row$(id)_x_factor_x_positive.tsv")

            BioLab.Table.write(ts, BioLab.DataFrame.make(nar, ro_, fa_, w))

            ht = BioLab.Path.replace_extension(ts, "html")

        end

        or_ = BioLab.Clustering.hierarchize(w, 1).order

        co = copy(w)

        BioLab.Matrix.apply_by_row!(fu, co)

        BioLab.Plot.plot_heat_map(
            co[or_, :],
            ro_[or_],
            fa_;
            nar,
            nac = naf,
            layout = Dict(
                "height" => lo,
                "width" => sh,
                "title" => Dict("text" => "W$id"),
                "xaxis" => axis,
            ),
            ht,
        )

    end

    for (id, (h, co_, nac)) in enumerate(zip(h_, co___, nac_))

        title_text = "factor_x_column$(id)_x_positive"

        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            BioLab.Table.write(
                joinpath(di, "$title_text.tsv"),
                BioLab.DataFrame.make(naf, fa_, co_, h),
            )

        end

        or_ = BioLab.Clustering.hierarchize(h, 2).order

        co = copy(h)

        BioLab.Matrix.apply_by_column!(fu, co)

        BioLab.Plot.plot_heat_map(
            co[:, or_],
            fa_,
            co_[or_];
            nar = naf,
            nac,
            layout = Dict(
                "height" => sh,
                "width" => lo,
                "title" => Dict("text" => "H$id"),
                "yaxis" => axis,
            ),
            ht,
        )

    end

    return nothing

end

function factorize(a, n; ve = true, ke_ar...)

    mf = nnmf(a, n; init = :nndsvd, alg = :multmse, maxiter = 10^6, tol = 10^-5)

    if !mf.converged

        @warn "Did not converge." mf.objvalue

    end

    if ve

        println("♻️ $(mf.niters) iterations.")

        println("🏁 Objective value $(BioLab.Number.format(mf.objvalue)).")

        plot((mf.W,), (mf.H,); ke_ar...)

    end

    return mf.W::Matrix{Float64}, mf.H::Matrix{Float64}

end

function solve_h(a, w)

    return clamp!(pinv(w) * a, 0, Inf)

end

end
