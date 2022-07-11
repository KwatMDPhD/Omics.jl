function _plot(ve_, na_, la, title_text)

    OnePiece.figure.plot_x_y(ve_, name_ = na_, la = merge(la, Dict("title_text" => title_text)))

end

function try_method(fe_, sc_, fe1_; ex = 1.0, plp = true, pl = true)

    in_ = convert(Vector{Float64}, OnePiece.vector.is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    ab_ = abs.(sc_) .^ ex

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    abl_, abr_ = _cumulate(ab_)

    inal_, inar_ = _cumulate(ina_)

    oual_, ouar_ = _cumulate(oua_)

    oul_, our_ = _cumulate(ou_)

    if plp

        la = Dict("xaxis_title_text" => "Feature")

        if length(fe_) < 100

            la = merge(la, Dict("xaxis_tickvals" => 1:length(fe_), "xaxis_ticktext" => fe_))

        end

        _plot([sc_, in_], ["Score", "In"], la, "Input")

        na_ = ["Value", "PDF", "Right CDF ", "Left CDF"]

        _plot([ab_, abl_, abr_], na_, la, "Absolute")

        _plot([ina_, inal_, inar_], na_, la, "In * Absolute")

        _plot([oua_, oual_, ouar_], na_, la, "Out * Absolute")

    end

    me_en = OrderedDict()

    for (me, fl_, fr_) in [
        ["Ou < KS", inal_, oul_],
        [
            "OuA <> KLC",
            OnePiece.information.get_kullback_leibler_divergence(inal_, abl_),
            OnePiece.information.get_kullback_leibler_divergence(inar_, abr_),
        ],
        [
            "OuA < SKLC",
            OnePiece.information.get_symmetric_kullback_leibler_divergence(inal_, oual_, abl_),
            OnePiece.information.get_symmetric_kullback_leibler_divergence(inar_, ouar_, abr_),
        ],
        [
            "OuA < AKLC",
            OnePiece.information.get_antisymmetric_kullback_leibler_divergence(inal_, oual_, abl_),
            OnePiece.information.get_antisymmetric_kullback_leibler_divergence(inar_, ouar_, abr_),
        ],
    ]

        en_ = fl_ - fr_

        for (me2, fu2) in
            [["Extreme", OnePiece.tensor.get_extreme], ["Area", OnePiece.tensor.get_area]]

            en = fu2(en_)

            me_en["$me $me2"] = en

            if plp

                _plot([fl_, fr_, en_], ["Left", "Right", "Enrichment"], la, me)

            end

            if pl

                _plot_mountain(fe_, sc_, in_, en_, en, title_text = me)

            end

        end

    end

    me_en

end

function try_method(fe_, sc_, se_fe_::Dict; ex = 1.0)

    Dict(
        se => try_method(fe_, sc_, fe1_, ex = ex, plp = false, pl = false) for (se, fe1_) in se_fe_
    )

end
