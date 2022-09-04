function factorize(
    ma,
    n_fa,
    ro_ = ["Row $id" for id in 1:size(ma, 1)],
    co_ = ["Column $id" for id in 1:size(ma, 2)],
)

    mf = nnmf(ma, n_fa, maxiter = Int(1e6))

    if !mf.converged

        error()

    end

    println(
        "Iterations = $(mf.niters) and objective value = $(OnePiece.number.format(mf.objvalue))",
    )

    plot([mf.W], [mf.H], [ro_], [co_])

    mf.W, mf.H

end
