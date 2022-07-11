function _cumulate(ve)

    ep = eps()

    cul_ = OnePiece.tensor.cumulate_sum_reverse(ve) .+ ep

    cul_ /= sum(ve)

    cur_ = cumsum(ve) .+ ep

    cur_ /= sum(ve)

    cul_, cur_

end

function score_set_new(fe_, sc_, fe1_; ex = 1.0, pl = true, ke_ar...)

    in_ = convert(Vector{Float64}, OnePiece.vector.is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    ab_ = abs.(sc_) .^ ex

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    abl_, abr_ = _cumulate(ab_)

    inal_, inar_ = _cumulate(ina_)

    oual_, ouar_ = _cumulate(oua_)

    fl_ = OnePiece.information.get_antisymmetric_kullback_leibler_divergence(inal_, oual_, abl_)

    fr_ = OnePiece.information.get_antisymmetric_kullback_leibler_divergence(inar_, ouar_, abr_)

    en_ = fl_ - fr_

    en = OnePiece.tensor.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    en

end

function score_set_new(fe_, sc_, se_fe_::Dict; ex = 1.0, n_jo = 1)

    Dict(se => score_set_new(fe_, sc_, fe1_, ex = ex, pl = false) for (se, fe1_) in se_fe_)

end
