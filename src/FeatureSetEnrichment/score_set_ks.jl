function score_set_ks(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su1, su0 = _sum_1_and_0(sc_, bo_)

    cu = 0.0

    de = 1.0 / su0

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    eta = 0.0

    et = 0.0

    @inbounds @fastmath @simd for id in n:-1:1

        if bo_[id]

            cu += _get_1(sc_, id, ex) / su1

        else

            cu -= de

        end

        if pl

            en_[id] = cu

        end

        if cu < 0.0

            cua = -cu

        else

            cua = cu

        end

        if eta < cua

            eta = cua

            et = cu

        end

    end

    if pl

        _plot_mountain(fe_, sc_, bo_, en_, et; ke_ar...)

    end

    et

end
