function _cumulate(ve)

    ep = eps()

    cul_ = OnePiece.tensor.cumulate_sum_reverse(ve) .+ ep

    cul_ /= sum(cul_)

    # To do #

    # Kwat
    #cur_ = cumsum(ve) .+ ep
    #cur_ /= sum(cur_)

    # Pablo
    cur_ = 1.0 .- cul_

    println("Sums: $(sum(cul_)) and $(sum(cur_))")

    # ----- #

    cul_, cur_

end

function score_set_new(fe_, sc_, fe1_; ex = 1.0, pl = true, ke_ar...)

    in_ = convert(Vector{Float64}, OnePiece.vector.is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    ab_ = abs.(sc_) .^ ex

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    inapl_, inapr_ = _cumulate(ina_)

    ouapl_, ouapr_ = _cumulate(oua_)

    fl_ = OnePiece.information.get_kullback_leibler_divergence(inapl_, ouapl_)

    fr_ = OnePiece.information.get_kullback_leibler_divergence(inapr_, ouapr_)

    en_ = fl_ - fr_

    # To do #

    # Kwat
    #en = OnePiece.tensor.get_area(en_)

    # Pablo
    en = sum(en_)

    # ----- #

    if pl

        _plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    en

end

function score_set_new(fe_, sc_, se_fe_::Dict; ex = 1.0, n_jo = 1)

    Dict(se => score_set_new(fe_, sc_, fe1_, ex = ex, pl = false) for (se, fe1_) in se_fe_)

end
