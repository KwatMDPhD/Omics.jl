module MatrixFactorization

using NMF: nnmf

using NonNegLeastSquares: nonneg_lsq

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
