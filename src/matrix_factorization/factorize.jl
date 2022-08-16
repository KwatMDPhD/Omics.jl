function factorize(
    ma,
    n_fa,
    ro_ = ["Row $id" for id in 1:size(ma, 1)],
    co_ = ["Column $id" for id in 1:size(ma, 2)],
)

    mf = nnmf(ma, n_fa)

    println(
        "Iterations = $(mf.niters), objective value = $(mf.objvalue), and converged = $(mf.converged)",
    )

    plot([mf.W], [mf.H], [ro_], [co_])

end
