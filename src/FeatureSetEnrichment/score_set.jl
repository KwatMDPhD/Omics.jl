function score_set(al, fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    _match_algorithm(al)(
        fe_,
        sc_,
        fe1_,
        BioLab.Vector.is_in(fe_, fe1_);
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end

function score_set(al, fe_, sc_, se_fe_; ex = 1.0)

    if length(se_fe_) < 2

        ch = fe_

    else

        ch = Dict(fe => id for (id, fe) in enumerate(fe_))

    end

    Dict(
        se => _match_algorithm(al)(
            fe_,
            sc_,
            fe1_,
            BioLab.Vector.is_in(ch, fe1_);
            ex = ex,
            pl = false,
        ) for (se, fe1_) in se_fe_
    )

end

function score_set(al, fe_x_sa_x_sc, se_fe_; ex = 1.0)

    fe_, sa_, fe_x_sa_x_sc = BioLab.DataFrame.separate(fe_x_sa_x_sc)[[2, 3, 4]]

    BioLab.Array.error_duplicate(fe_)

    BioLab.Matrix.error_bad(fe_x_sa_x_sc, Real)

    se_x_sa_x_en = DataFrame("Set" => collect(keys(se_fe_)))

    for (id, sa) in enumerate(sa_)

        go_ = findall(!ismissing, fe_x_sa_x_sc[:, id])

        sc_, fe_ = BioLab.Vector.sort_like((fe_x_sa_x_sc[go_, id], fe_[go_]))

        se_en = score_set(al, fe_, sc_, se_fe_; ex = ex)

        se_x_sa_x_en[!, sa] = [se_en[se] for se in se_x_sa_x_en[!, "Set"]]

    end

    se_x_sa_x_en

end
