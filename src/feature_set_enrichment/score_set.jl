function score_set(fe_, sc_, fe1_, in_; ex = 1.0, al = "kolmogorov_smirnov", pl = true, ke_ar...)

    n_fe = length(fe_)

    en = 0.0

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

            en += sc / su1

        else

            en -= de

        end

        if pl

            en_[id] = en

        end

        ar += en

        if en < 0.0

            ena = -en

        else

            ena = en

        end

        if exa < ena

            exa = ena

            ex = en

        end

    end

    if al == "kolmogorov_smirnov"

        en = ex

    elseif al == "kolmogorov_smirnov_area"

        en = ar / convert(Float64, n_fe)

    end

    if pl

        _plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    en

end

function score_set(fe_, sc_, fe1_; ex = 1.0, al = "kolmogorov_smirnov", pl = true, ke_ar...)

    score_set(
        fe_,
        sc_,
        fe1_,
        OnePiece.vector.is_in(fe_, fe1_);
        ex = ex,
        al = al,
        pl = pl,
        ke_ar...,
    )

end

function score_set(fe_, sc_, se_fe_::Dict; ex = 1.0, al = "kolmogorov_smirnov", n_jo = 1)

    if length(se_fe_) < 10

        ch = fe_

    else

        ch = Dict(fe => id for (fe, id) in zip(fe_, 1:length(fe_)))

    end

    Dict(
        se => score_set(
            fe_,
            sc_,
            fe1_,
            OnePiece.vector.is_in(ch, fe1_),
            ex = ex,
            al = al,
            pl = false,
        ) for (se, fe1_) in se_fe_
    )

end

function score_set(sc_fe_sa, se_fe_; ex = 1.0, al = "kolmogorov_smirnov", n_jo = 1)

    fe_ = sc_fe_sa[!, 1]

    en_se_sa = DataFrame("Set" => collect(keys(se_fe_)))

    for sa in names(sc_fe_sa)[2:end]

        go_ = findall(!ismissing, sc_fe_sa[!, sa])

        sc_, fe_ = OnePiece.vector.sort_like(sc_fe_sa[go_, sa], fe_[go_])

        if in(al, ["kolmogorov_smirnov", "kolmogorov_smirnov_area"])

            se_en = score_set(fe_, sc_, se_fe_, ex = ex, al = al)

        elseif al == "jensen_shannon"

            se_en = score_set_new(fe_, sc_, se_fe_)

        end

        en_se_sa[!, sa] = collect(se_en[se] for se in en_se_sa[!, "Set"])

    end

    en_se_sa

end
