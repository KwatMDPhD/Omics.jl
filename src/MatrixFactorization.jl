module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

function plot(
    ro_x_fa_x_po_,
    fa_x_co_x_po_;
    nar_ = ["Rows $id" for id in eachindex(ro_x_fa_x_po_)],
    nac_ = ["Columns $id" for id in eachindex(fa_x_co_x_po_)],
    naf = "Factor",
    ro__ = (["$na $id" for id in 1:size(ma, 1)] for (ma, na) in zip(ro_x_fa_x_po_, nar_)),
    co__ = (["$na $id" for id in 1:size(ma, 2)] for (ma, na) in zip(fa_x_co_x_po_, nac_)),
    di = "",
)

    fa_ = ["$naf $id" for id in 1:size(ro_x_fa_x_po_[1], 2)]

    lo = 800

    sh = lo / MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (ro_x_fa_x_po, ro_, nar)) in enumerate(zip(ro_x_fa_x_po_, ro__, nar_))

        title_text = "row$(id)_x_factor_x_positive"

        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            BioLab.Table.write(
                joinpath(di, "$title_text.tsv"),
                BioLab.DataFrame.make(nar, ro_, fa_, ro_x_fa_x_po),
            )

        end

        di = 1

        or_ = BioLab.Clustering.hierarchize(ro_x_fa_x_po, di).order

        BioLab.Plot.plot_heat_map(
            BioLab.Normalization.normalize(ro_x_fa_x_po[or_, :], "-0-"; di),
            ro_[or_],
            fa_;
            nar,
            nac = naf,
            layout = Dict(
                "height" => lo,
                "width" => sh,
                "title" =>
                    Dict("text" => BioLab.String.title(replace(title_text, "_x_" => "_by_"))),
                "xaxis" => axis,
            ),
            ht,
        )

    end

    for (id, (fa_x_co_x_po, co_, nac)) in enumerate(zip(fa_x_co_x_po_, co__, nac_))

        title_text = "factor_x_column$(id)_x_positive"

        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            BioLab.Table.write(
                joinpath(di, "$title_text.tsv"),
                BioLab.DataFrame.make(naf, fa_, co_, fa_x_co_x_po),
            )

        end

        di = 2

        or_ = BioLab.Clustering.hierarchize(fa_x_co_x_po; di).order

        BioLab.Plot.plot_heat_map(
            BioLab.Normalization.normalize(fa_x_co_x_po[!, or_], "-0-"; di),
            fa_,
            co_[or_],
            nar = naf,
            nac,
            layout = Dict(
                "height" => sh,
                "width" => lo,
                "title" =>
                    Dict("text" => BioLab.String.title(replace(title_text, "_x_" => "_by_"))),
                "yaxis" => axis,
            ),
            ht,
        )

    end

    return nothing

end

function factorize(ro_x_co_x_po, n; ke_ar...)

    mf = nnmf(ro_x_co_x_po, n; init = :random, alg = :multmse, tol = 10^-6, maxiter = 10^6)

    if !mf.converged

        error()

    end

    println("♻️ Iterations: $(mf.niters)")

    println("🏁 Objective value: $(BioLab.Number.format(mf.objvalue))")

    plot((mf.W,), (mf.H,); ke_ar...)

    return mf.W, mf.H

end

function solve_h(ro_x_co_x_po, ro_x_fa_x_po)

    return pinv(ro_x_fa_x_po) * ro_x_co_x_po

end

end
