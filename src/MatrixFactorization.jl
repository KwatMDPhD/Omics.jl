module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

function factorize(ma, n; ke_ar...)

    mf = nnmf(ma, n; ke_ar...)

    if mf.converged

        mf.W, mf.H

    else

        @warn "Did not converge. niters = $(mf.niters). objvalue = $(mf.objvalue)."

    end

end

# TODO: Improve.
function solve_h(ma, w)

    clamp!(pinv(w) * ma, 0, Inf)

end

function write(
    di,
    w_,
    h_;
    no = true,
    nar_ = ["Rows $id" for id in eachindex(w_)],
    nac_ = ["Columns $id" for id in eachindex(h_)],
    naf = "Factor",
    ro___ = (["$na $id" for id in 1:size(ma, 1)] for (ma, na) in zip(w_, nar_)),
    co___ = (["$na $id" for id in 1:size(ma, 2)] for (ma, na) in zip(h_, nac_)),
)

    BioLab.Error.error_missing(di)

    lo = 1280

    sh = 800

    fa_ = ["$naf $id" for id in 1:size(w_[1], 2)]

    axis = Dict("dtick" => 1)

    for (id, (w, nar, ro_)) in enumerate(zip(w_, nar_, ro___))

        pr = joinpath(di, "row$(id)_x_factor_x_positive")

        BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(nar, ro_, fa_, w))

        or_ = BioLab.Clustering.hierarchize(w, 1).order

        if no

            w = copy(w)

            foreach(BioLab.Normalization.normalize_with_0!, eachrow(w))

        end

        BioLab.Plot.plot_heat_map(
            "$pr.html",
            view(w, or_, :),
            view(ro_, or_),
            fa_;
            nar,
            nac = naf,
            layout = Dict(
                "height" => lo,
                "width" => sh,
                "title" => Dict("text" => "W $id"),
                "xaxis" => axis,
            ),
        )

    end

    for (id, (h, nac, co_)) in enumerate(zip(h_, nac_, co___))

        pr = joinpath(di, "factor_x_column$(id)_x_positive")

        BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(naf, fa_, co_, h))

        or_ = BioLab.Clustering.hierarchize(h, 2).order

        if no

            h = copy(h)

            foreach(BioLab.Normalization.normalize_with_0!, eachcol(h))

        end

        BioLab.Plot.plot_heat_map(
            "$pr.html",
            view(h, :, or_),
            fa_,
            view(co_, or_);
            nar = naf,
            nac,
            layout = Dict(
                "height" => sh,
                "width" => lo,
                "title" => Dict("text" => "H $id"),
                "yaxis" => axis,
            ),
        )

    end

    di

end

end
