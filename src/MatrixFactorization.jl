module MatrixFactorization

using NMF: nnmf

using NonNegLeastSquares: nonneg_lsq

using ..Nucleus

function factorize(ma, n_fa; ke_ar...)

    re = nnmf(ma, n_fa; ke_ar...)

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

# TODO: Test.
function write(
    di,
    ma;
    nl = "Label",
    nf = "Factor",
    la_ = (id -> "$nl $id").(1:maximum(size(ma))),
    fa_ = (id -> "$nf $id").(1:minimum(size(ma))),
    no = false,
    lo = Nucleus.HTML.WI,
    sh = Nucleus.HTML.HE,
)

    n_fa, id = findmin(size(ma))

    if isone(id)

        wh = "H"

        nr = nf

        nc = nl

        ro_ = fa_

        co_ = la_

        height = sh

        width = lo

        ax = "y"

        mc = ma

    else

        wh = "W"

        nr = nl

        nc = nf

        ro_ = la_

        co_ = fa_

        height = lo

        width = sh

        ax = "x"

        mc = permutedims(ma)

    end

    pr = joinpath(di, "$n_fa$(lowercase(wh))")

    Nucleus.DataFrame.write("$pr.tsv", nr, ro_, co_, ma)

    id_ =
        Nucleus.Clustering.hierarchize(
            # TODO: Use information.
            Nucleus.Distance.get(Nucleus.Distance.Euclidean(), mc),
        ).order

    if isone(id)

        ma = ma[:, id_]

        co_ = co_[id_]

    else

        ma = ma[id_, :]

        ro_ = ro_[id_]

    end

    if no

        foreach(Nucleus.Normalization.normalize_with_0!, (isone(id) ? eachcol : eachrow)(ma))

    end

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        ma;
        y = ro_,
        x = co_,
        nr,
        nc,
        layout = Dict(
            "height" => height,
            "width" => width,
            "title" => Dict("text" => wh),
            "$(ax)axis" => Dict("dtick" => 1),
        ),
    )

end

end
