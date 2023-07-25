module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using BioLab

function factorize(ma, n; ke_ar...)

    mf = nnmf(ma, n; ke_ar...)

    st = " in $(mf.niters) iterations with $(mf.objvalue)."

    if mf.converged

        @info "Converged$st"

    else

        error("Did not converge$st")

    end

    mf.W, mf.H

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
    nar_ = string.("Row Set ", eachindex(w_)),
    nac_ = string.("Column Set ", eachindex(h_)),
    naf = "Factor",
    ro___ = (string.("$na ", 1:size(ma, 1)) for (ma, na) in zip(w_, nar_)),
    co___ = (string.("$na ", 1:size(ma, 2)) for (ma, na) in zip(h_, nac_)),
)

    BioLab.Path.error_missing(di)

    lo = 1280

    sh = 800

    fa_ = string.("$naf ", 1:size(w_[1], 2))

    axis = BioLab.Dict.merge_recursively(BioLab.Plot.AXIS, Dict("dtick" => 1))

    for (id, (w, nar, ro_)) in enumerate(zip(w_, nar_, ro___))

        pr = joinpath(di, "row$(id)_x_factor_x_positive")

        BioLab.Table.write("$pr.tsv", BioLab.DataFrame.make(nar, ro_, fa_, w))

        or_ = BioLab.Clustering.hierarchize(w, 1).order

        if no

            w = copy(w)

            foreach(BioLab.Number.normalize_with_0!, eachrow(w))

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
                "title" => Dict("text" => "W$id"),
                "xaxis" => axis,
            ),
        )

    end

    for (id, (h, nac, co_)) in enumerate(zip(h_, nac_, co___))

        pr = joinpath(di, "factor_x_column$(id)_x_positive")

        BioLab.Table.write("$pr.tsv", BioLab.DataFrame.make(naf, fa_, co_, h))

        or_ = BioLab.Clustering.hierarchize(h, 2).order

        if no

            h = copy(h)

            foreach(BioLab.Number.normalize_with_0!, eachcol(h))

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
                "title" => Dict("text" => "H$id"),
                "yaxis" => axis,
            ),
        )

    end

end

end
