using Plotly: Layout

using ..information:
    get_kullback_leibler_divergence,
    get_relative_information_difference,
    get_relative_information_sum,
    get_symmetric_information_difference,
    get_symmetric_information_sum
using ..plot: plot_x_y
using ..vector: check_in, sort_like
using ..vector_number: get_area, get_extreme

function get_kolmogorov_smirnov(ve1::VF, ve2::VF)::VF

    return ve1 - ve2

end

function try_method(
    fe_::VS,
    sc_::VF,
    fe1_::VS;
    so::Bool = true,
    plp::Bool = true,
    pl::Bool = true,
)::ODSF

    if so

        sc_, fe_ = sort_like(sc_, fe_)

    end

    in_ = check_in(fe_, fe1_)

    ab_ = abs.(sc_)

    ina_ = in_ .* ab_

    ou_ = 1.0 .- in_

    oua_ = ou_ .* ab_

    abp_, abpr_, abpl_ = _get_probability_and_cumulative_probability(ab_)

    inap_, inapr_, inapl_ = _get_probability_and_cumulative_probability(ina_)

    oup_, oupr_, oupl_ = _get_probability_and_cumulative_probability(ou_)

    ouap_, ouapr_, ouapl_ = _get_probability_and_cumulative_probability(oua_)

    if plp

        layout = Layout(xaxis_title = "Feature")

        if length(fe_) < 100

            layout =
                merge(layout, Layout(xaxis_tickvals = 1:length(fe_), xaxis_ticktext = fe_))

        end

        plot_x_y(
            [sc_, in_];
            name_ = ["Score", "In"],
            layout = merge(layout, Layout(title = "Input")),
        )

        plot_x_y(
            [ab_, abp_, abpr_, abpl_];
            name_ = ["v", "P", "Cr", "Cl"],
            layout = merge(layout, Layout(title = "Absolute")),
        )

        plot_x_y(
            [ina_, inap_, inapr_, inapl_];
            name_ = ["v", "P", "Cr", "Cl"],
            layout = merge(layout, Layout(title = "In * Absolute")),
        )

        plot_x_y(
            [ou_, oup_, oupr_, oupl_];
            name_ = ["v", "P", "Cr", "Cl"],
            layout = merge(layout, Layout(title = "Out")),
        )

        plot_x_y(
            [oua_, ouap_, ouapr_, ouapl_];
            name_ = ["v", "P", "Cr", "Cl"],
            layout = merge(layout, Layout(title = "Out * Absolute")),
        )

    end

    me_en = ODSF()

    for (me1, our_, oul_) in [["ou", oupr_, oupl_], ["oua", ouapr_, ouapl_]]

        for (me2, fu1) in [
            ["ks", get_kolmogorov_smirnov],
            ["ris", get_relative_information_sum],
            ["risw", get_relative_information_sum],
            ["rid", get_relative_information_difference],
            ["ridw", get_relative_information_difference],
            ["sis", get_symmetric_information_sum],
            ["sid", get_symmetric_information_difference],
        ]

            if endswith(me2, 'w')

                arl = [abpl_]

                arr = [abpr_]

            else

                arl = []

                arr = []

            end

            fr_ = fu1(inapr_, our_, arr...)

            fl_ = fu1(inapl_, oul_, arl...)

            for (me3, en_) in [[">", fr_], ["<", fl_], ["<>", fl_ - fr_]]

                for (me4, fu2) in [["area", get_area], ["extreme", get_extreme]]

                    me = join([me1, me3, me2, me4], " ")

                    en = fu2(en_)

                    me_en[me] = en

                    if plp


                        plot_x_y(
                            [fl_, fr_, en_];
                            name_ = ["Fl", "Fr", "Enrichment"],
                            layout = merge(layout, Layout(title = "Enrichment")),
                        )

                    end

                    if pl

                        plot_mountain(fe_, sc_, in_, en_, en; title = me)

                    end

                end

            end

        end

    end

    return me_en

end


function try_method(fe_::VS, sc_::VF, se_fe_::DSVS; so::Bool = true)::DSODSF

    if so

        sc_, fe_ = sort_like(sc_, fe_)

    end

    se_me_en = DSODSF()

    for (se, fe1_) in se_fe_

        se_me_en[se] = try_method(fe_, sc_, fe1_; so = false, plp = false, pl = false)

    end

    return se_me_en

end

export try_method
