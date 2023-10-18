module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

function factorize(ma, n; init = :nndsvd, alg = :greedycd, maxiter = 10^6, tol = 1e-6, ke_ar...)

    re = nnmf(ma, n; init, alg, maxiter, tol, ke_ar...)

    if re.converged

        re.W, re.H

    else

        @warn "Failed to converge." re.niters re.objvalue

    end

end

function solve_h(ma, mw)

    clamp!(pinv(mw) * ma, 0, Inf)

end

function write(
    di,
    ma;
    nal = "Label",
    naf = "Factor",
    la_ = (id -> "$nal $id").(1:maximum(size(ma))),
    fa_ = (id -> "$naf $id").(1:minimum(size(ma))),
    no = true,
    lo = BioLab.HTML.WI,
    sh = BioLab.HTML.HE,
)

    BioLab.Error.error_missing(di)

    id = findmax(size(ma))[2]

    if isone(id)

        wh = "W"

        nar = nal

        nac = naf

        ro_ = la_

        co_ = fa_

        ma2 = permutedims(ma)

    else

        wh = "H"

        nar = naf

        nac = nal

        ro_ = fa_

        co_ = la_

        ma2 = ma

    end

    pr = joinpath(di, lowercase(wh))

    BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(nar, ro_, co_, ma))

    id_ = BioLab.Clustering.hierarchize(ma2).order

    if isone(id)

        ma = ma[id_, :]

        ro_ = ro_[id_]

        ea = eachrow

        height, width = lo, sh

        ax = "x"

    else

        ma = ma[:, id_]

        co_ = co_[id_]

        ea = eachcol

        height, width = sh, lo

        ax = "y"

    end

    if no

        foreach(BioLab.Normalization.normalize_with_0!, ea(ma))

    end

    BioLab.Plot.plot_heat_map(
        "$pr.html",
        ma;
        y = ro_,
        x = co_,
        nar,
        nac,
        layout = Dict(
            "height" => height,
            "width" => width,
            "title" => Dict("text" => wh),
            "$(ax)axis" => Dict("dtick" => 1),
        ),
    )

end

end
