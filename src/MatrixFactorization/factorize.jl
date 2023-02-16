function factorize(ro_x_co_x_po, n; ke_ar...)

    mf = nnmf(ro_x_co_x_po, n; init = :random, alg = :multmse, tol = 10^-6, maxiter = 10^6)

    if !mf.converged

        error()

    end

    println("♻️ Iterations: $(mf.niters)")

    println("🏁 Objective value: $(BioLab.Number.format(mf.objvalue))")

    plot((mf.W,), (mf.H,); ke_ar...)

    return mf.W, mf.H

end
