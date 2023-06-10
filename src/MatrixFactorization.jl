module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

function factorize(a, n)

    mf = nnmf(a, n; init = :random, alg = :multdiv, maxiter = 10^5, tol = 10^-4)

    me = " in $(mf.niters) iterations with $(mf.objvalue)."

    if mf.converged

        @info "Converged$me"

    else

        error("Did not converge$me")

    end

    mf.W, mf.H

end

function solve_h(a, w)

    clamp!(pinv(w) * a, 0, Inf)

end

function write(
    w_,
    h_;
    fu = nothing,
    nar_ = ["Rows $id" for id in eachindex(w_)],
    nac_ = ["Columns $id" for id in eachindex(h_)],
    naf = "Factor",
    ro___ = (["$na $id" for id in 1:size(ma, 1)] for (ma, na) in zip(w_, nar_)),
    co___ = (["$na $id" for id in 1:size(ma, 2)] for (ma, na) in zip(h_, nac_)),
    di = "",
)

    fa_ = ["$naf $id" for id in 1:size(w_[1], 2)]

    lo = 1280

    sh = 800

    axis = Dict("dtick" => 1)

    for (id, (w, ro_, nar)) in enumerate(zip(w_, ro___, nar_))

        pr = "row$(id)_x_factor_x_positive"

        if isempty(di)

            ht = ""

        else

            BioLab.Table.write(joinpath(di, "$pr.tsv"), BioLab.DataFrame.make(nar, ro_, fa_, w))

            ht = joinpath(di, "$pr.html")

        end

        or_ = BioLab.Clustering.hierarchize(w, 1).order

        co = copy(w)

        if !isnothing(fu)

            map!(fu, eachrow(co), eachrow(co))

        end

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

        pr = "factor_x_column$(id)_x_positive"

        if isempty(di)

            ht = ""

        else

            BioLab.Table.write(joinpath(di, "$pr.tsv"), BioLab.DataFrame.make(naf, fa_, co_, h))

            ht = joinpath(di, "$pr.html")

        end

        or_ = BioLab.Clustering.hierarchize(h, 2).order

        co = copy(h)

        if !isnothing(fu)

            map!(fu, eachcol(co), eachcol(co))

        end

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

end

end
