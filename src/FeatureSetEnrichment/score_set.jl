function score_set(al, fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    return _match_algorithm(al)(
        fe_,
        sc_,
        BioLab.Vector.is_in(fe_, Set(fe1_));
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end

function score_set(al, fe_, sc_, se_fe_; ex = 1.0)

    ch = Dict(fe => id for (id, fe) in enumerate(fe_))

    #sc_, fe_ = BioLab.Vector.sort_like((sc_, fe_); de=true)

    return Dict(
        se => _match_algorithm(al)(fe_, sc_, BioLab.Vector.is_in(ch, fe1_); ex = ex, pl = false)
        for (se, fe1_) in se_fe_
    )

end

function score_set(al, fe_x_sa_x_sc, se_fe_; ex = 1.0, n_jo = 1)

    fe_::Vector{String}, sa_::Vector{String}, fe_x_sa_x_sc::Matrix{Float64} =
        BioLab.DataFrame.separate(fe_x_sa_x_sc)[[2, 3, 4]]

    BioLab.Array.error_duplicate(fe_)

    #BioLab.Matrix.error_bad(fe_x_sa_x_sc, Float64)

    se_x_sa_x_en = DataFrame("Set" => collect(keys(se_fe_)))

    # TODO: Parallelize.
    for (id, sa) in enumerate(sa_)

        go_ = findall(!ismissing, fe_x_sa_x_sc[:, id])

        sc_, fe_ = BioLab.Vector.sort_like((fe_x_sa_x_sc[go_, id], fe_[go_]); de = true)

        se_en = score_set(al, fe_, sc_, se_fe_; ex)

        se_x_sa_x_en[!, sa] = [se_en[se] for se in se_x_sa_x_en[!, "Set"]]

    end

    return se_x_sa_x_en

end
