function factorize(ma, n_fa; ke_ar...)

    mf = nnmf(ma, n_fa, maxiter = Int(1e6))

    if !mf.converged

        error()

    end

    println(
        "Iterations = $(mf.niters) and objective value = $(OnePiece.number.format(mf.objvalue))",
    )

    plot([mf.W], [mf.H]; ke_ar...)

    mf.W, mf.H

end
