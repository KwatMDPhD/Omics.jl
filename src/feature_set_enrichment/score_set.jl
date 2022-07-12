function _sum_1_absolute_and_0_count(sc_::Vector{Float64}, in_::Vector{Bool})

    su1 = 0.0

    su0 = 0.0

    @inbounds @fastmath @simd for id in 1:length(sc_)

        if in_[id]

            nu = sc_[id]

            if nu < 0.0

                nu = -nu

            end

            su1 += nu

        else

            su0 += 1.0

        end

    end

    su1, su0

end

function score_set(fe_, sc_, fe1_, in_; ex = 1.0, pl = true, ke_ar...)

    n_fe = length(fe_)

    cu = 0.0

    en_ = Vector{Float64}(undef, n_fe)

    ex = 0.0

    exa = 0.0

    ar = 0.0

    su1, su0 = _sum_1_absolute_and_0_count(sc_, in_)

    de = 1.0 / su0

    @inbounds @fastmath @simd for id in n_fe:-1:1

        if in_[id] == 1.0

            sc = sc_[id]

            if sc < 0.0

                sc = -sc

            end

            cu += sc / su1

        else

            cu -= de

        end

        if pl

            en_[id] = cu

        end

        ar += cu

        if cu < 0.0

            ena = -cu

        else

            ena = cu

        end

        if exa < ena

            exa = ena

            ex = cu

        end

    end

    en = ex, ar / convert(Float64, n_fe)

    if pl

        _plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    en

end

function score_set(fe_, sc_, fe1_; ex = 1.0, pl = true, ke_ar...)

    score_set(fe_, sc_, fe1_, OnePiece.vector.is_in(fe_, fe1_); ex = ex, pl = pl, ke_ar...)

end

function score_set(fe_, sc_, se_fe_::Dict; ex = 1.0, n_jo = 1)

    if length(se_fe_) < 10

        ch = fe_

    else

        ch = Dict(fe => id for (fe, id) in zip(fe_, 1:length(fe_)))

    end

    Dict(
        se => score_set(fe_, sc_, fe1_, OnePiece.vector.is_in(ch, fe1_), ex = ex, pl = false) for
        (se, fe1_) in se_fe_
    )

end

function score_set(fe_x_sa_x_sc, se_fe_; al = "cidac", ex = 1.0, n_jo = 1)

    fe_, fe_x_sa_x_sc = OnePiece.dataframe.separate_row(fe_x_sa_x_sc)

    OnePiece.vector.error_duplicate(fe_)

    OnePiece.dataframe.error_bad(fe_x_sa_x_sc)

    se_x_sa_x_en = DataFrame("Set" => collect(keys(se_fe_)))

    for sa in names(fe_x_sa_x_sc)

        go_ = findall(!ismissing, fe_x_sa_x_sc[!, sa])

        sc_, fe_ = OnePiece.vector.sort_like(fe_x_sa_x_sc[go_, sa], fe_[go_])

        fu, st = _match_algorithm(al)

        se_en = _match_algorithm(fu(fe_, sc_, se_fe_, ex = ex), st)

        se_x_sa_x_en[!, sa] = collect(se_en[se] for se in se_x_sa_x_en[!, "Set"])

    end

    se_x_sa_x_en

end
