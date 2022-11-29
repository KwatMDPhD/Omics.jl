# TODO: Refactor API, decouple extreme and area

function _sum_1_absolute_and_0_count(sc_, bi_)

    #
    sut = 0.0

    suf = 0.0

    @inbounds @fastmath @simd for id in 1:length(sc_)

        #
        if bi_[id]

            #
            sc = sc_[id]

            #
            if sc < 0.0

                sc = -sc

            end

            #
            sut += sc

            #
        else

            suf += 1.0

        end

    end

    #
    sut, suf

end

function score_set(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    #
    n = length(fe_)

    #
    cu = 0.0

    en_ = Vector{Float64}(undef, n)

    eta = 0.0

    et = 0.0

    ar = 0.0

    #
    sut, suf = _sum_1_absolute_and_0_count(sc_, bi_)

    de = 1.0 / suf

    @inbounds @fastmath @simd for id in n:-1:1

        #
        if bi_[id]

            #
            sc = sc_[id]

            #
            if sc < 0.0

                sc = -sc

            end

            #
            cu += sc^ex / sut

            #
        else

            cu -= de

        end

        #
        if pl

            en_[id] = cu

        end

        #
        if cu < 0.0

            ena = -cu

        else

            ena = cu

        end

        if eta < ena

            eta = ena

            et = cu

        end

        #
        ar += cu

    end

    #
    ar /= n

    #
    if pl

        _plot_mountain(fe_, sc_, bi_, en_, et, ar; ke_ar...)

    end

    #
    et, ar

end

function score_set(fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    score_set(fe_, sc_, fe1_, BioLab.Vector.is_in(fe_, fe1_); ex = ex, pl = pl, ke_ar...)

end

function score_set(fe_, sc_, se_fe_; ex = 1.0)

    if length(se_fe_) < 2

        ch = fe_

    else

        ch = Dict(fe => id for (id, fe) in enumerate(fe_))

    end

    Dict(
        se => score_set(fe_, sc_, fe1_, BioLab.Vector.is_in(ch, fe1_), ex = ex, pl = false) for
        (se, fe1_) in se_fe_
    )

end

function score_set(fe_x_sa_x_sc, se_fe_; al = "cidac", ex = 1.0)

    #
    fe_, sa_, fe_x_sa_x_sc = BioLab.DataFrame.separate(fe_x_sa_x_sc)[[2, 3, 4]]

    BioLab.Array.error_duplicate(fe_)

    BioLab.Matrix.error_bad(fe_x_sa_x_sc, Real)

    #
    se_x_sa_x_en = DataFrame("Set" => collect(keys(se_fe_)))

    for (id, sa) in enumerate(sa_)

        #
        go_ = findall(!ismissing, fe_x_sa_x_sc[:, id])

        sc_, fe_ = BioLab.Vector.sort_like((fe_x_sa_x_sc[go_, id], fe_[go_]))

        #
        fu, id = _match_algorithm(al)

        se_en = Dict(se => en[id] for (se, en) in fu(fe_, sc_, se_fe_, ex = ex))

        #
        se_x_sa_x_en[!, sa] = [se_en[se] for se in se_x_sa_x_en[!, "Set"]]

    end

    #
    se_x_sa_x_en

end
