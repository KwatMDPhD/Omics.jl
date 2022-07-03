function plot_process(ve_, na_, la, title_text)

    OnePiece.figure.plot_x_y(ve_, name_ = na_, la = merge(la, Dict("title_text" => title_text)))

end

function try_method(fe_, sc_, fe1_; ex = 1.0, plp = true, pl = true)

    #
    in_ = convert(Vector{Float64}, OnePiece.vector.is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    #
    ab_ = abs.(sc_) .^ ex

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    #
    abp_, abpr_, abpl_ = _get_probability_and_cumulate(ab_)

    inap_, inapr_, inapl_ = _get_probability_and_cumulate(ina_)

    ouap_, ouapr_, ouapl_ = _get_probability_and_cumulate(oua_)

    oup_, oupr_, oupl_ = _get_probability_and_cumulate(ou_)

    if plp

        la = Dict("xaxis_title_text" => "Feature")

        if length(fe_) < 100

            la = merge(la, Dict("xaxis_tickvals" => 1:length(fe_), "xaxis_ticktext" => fe_))

        end

        plot_process([sc_, in_], ["Score", "In"], la, "Input")

        na_ = ["Value", "PDF", "Right CDF ", "Left CDF"]

        plot_process([ab_, abp_, abpr_, abpl_], na_, la, "Absolute")

        plot_process([ina_, inap_, inapr_, inapl_], na_, la, "In * Absolute")

        plot_process([oua_, ouap_, ouapr_, ouapl_], na_, la, "Out * Absolute")

        plot_process([ou_, oup_, oupr_, oupl_], na_, la, "Out")
    end

    me_en = OrderedDict()

    for (me1, our_, oul_) in [
        ["OuA", ouapr_, ouapl_],
        #["Ou", oupr_, oupl_],
    ]

        for (me2, fu1) in [
            ["KS", OnePiece.information.get_kolmogorov_smirnov_statistic],
            ["JS", OnePiece.information.get_jensen_shannon_divergence],
            ["KP", OnePiece.information.get_kwat_pablo_divergence],
            #["SB", OnePiece.information.get_thermodynamic_breadth],
            #["SD", OnePiece.information.get_thermodynamic_depth],
        ]

            if me2 in ["JS", "KP"]

                arl = [abpl_]

                arr = [abpr_]

            else

                arl = []

                arr = []

            end

            fr_ = fu1(inapr_, our_, arr...)

            fl_ = fu1(inapl_, oul_, arl...)

            for (me3, en_) in [
                #[">", fr_],
                ["<", fl_],
                ["<>", fl_ - fr_],
            ]

                for (me4, fu2) in [
                    ["Area", OnePiece.tensor.get_area],
                    #["Extreme", OnePiece.tensor.get_extreme],
                ]

                    me = join([me1, me3, me2, me4], " ")

                    en = fu2(en_)

                    me_en[me] = en

                    if plp

                        plot_process([fl_, fr_, en_], ["Left", "Right", "Enrichment"], la, me)

                    end

                    if pl

                        _plot_mountain(fe_, sc_, in_, en_, en, title_text = me)

                    end

                end

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
