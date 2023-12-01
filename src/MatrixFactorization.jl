module MatrixFactorization

using NMF: nnmf

using NonNegLeastSquares: nonneg_lsq

using ..Nucleus

function factorize(ma, n; ke_ar...)

    re = nnmf(ma, n; ke_ar...)

    me = "with $(re.niters) iterations at $(re.objvalue)."

    if re.converged

        @info "Converged $me"


    else

        @warn "Failed to converge $me"

    end

    re.W, re.H

end

function solve_h(mw, ma)

    mh = Matrix{Float64}(undef, size(mw, 2), size(ma, 2))

    for (id, co) in enumerate(eachcol(ma))

        mh[:, id] = nonneg_lsq(mw, co; alg = :nnls)

    end

    mh

end

function write(
    di,
    ma;
    nal = "Label",
    naf = "Factor",
    la_ = (id -> "$nal $id").(1:maximum(size(ma))),
    fa_ = (id -> "$naf $id").(1:minimum(size(ma))),
    no = true,
    lo = Nucleus.HTML.WI,
    sh = Nucleus.HTML.HE,
)

    Nucleus.Error.error_missing(di)

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

    Nucleus.DataFrame.write("$pr.tsv", nar, ro_, co_, ma)

    id_ = Nucleus.Clustering.hierarchize(ma2).order

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

        foreach(Nucleus.Normalization.normalize_with_0!, ea(ma))

    end

    Nucleus.Plot.plot_heat_map(
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
