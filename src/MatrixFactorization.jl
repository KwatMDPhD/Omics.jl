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

# TODO: Test.
function write(
    di,
    ma;
    nal = "Label",
    naf = "Factor",
    la_ = (id -> "$nal $id").(1:maximum(size(ma))),
    fa_ = (id -> "$naf $id").(1:minimum(size(ma))),
    no = false,
    lo = Nucleus.HTML.WI,
    sh = Nucleus.HTML.HE,
)

    n_fa, id = findmin(size(ma))

    nnaf = "$n_fa$naf"

    if isone(id)

        wh = "H"

        fi = "$(nnaf)_x_$(nal)_x_float"

        nar = naf

        nac = nal

        ro_ = fa_

        co_ = la_

        height = sh

        width = lo

        ax = "y"

        mac = ma

    else

        wh = "W"

        fi = "$(nal)_x_$(nnaf)_x_float"

        nar = nal

        nac = naf

        ro_ = la_

        co_ = fa_

        height = lo

        width = sh

        ax = "x"

        mac = permutedims(ma)

    end

    pr = joinpath(di, Nucleus.Path.clean(fi))

    Nucleus.DataFrame.write("$pr.tsv", nar, ro_, co_, ma)

    id_ =
        Nucleus.Clustering.hierarchize(
            # TODO: Use information.
            Nucleus.Distance.get(Nucleus.Distance.Euclidean(), mac),
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
