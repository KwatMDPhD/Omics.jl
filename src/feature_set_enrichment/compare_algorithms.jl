using OrderedCollections: OrderedDict
using Plotly: Layout

using Kwat.information: get_ided, get_ides, get_idrd, get_idrs, get_kld
using Kwat.plot: plot_x_y
using Kwat.vector_number: cumulate_sum_reverse, get_area, get_extreme
using Kwat.vector: check_in, sort_like

function get_ks(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return v1 - v2

end

function compare_algorithms(
    fe_::Vector{String},
    sc_::Vector{Float64},
    fe1_::Vector{String};
    so::Bool = true,
    plp::Bool = true,
    pl::Bool = true,
    ke...,
)::OrderedDict{String,Float64}

    if so

        sc_, fe_ = sort_like(sc_, fe_)

    end

    ab = abs.(sc_)

    is_h = check_in(fe_, fe1_)

    is_m = 1.0 .- is_h

    is_ha = is_h .* ab

    ep = eps()

    is_ha_p = is_ha / sum(is_ha)

    is_ha_p_cr = cumsum(is_ha_p) .+ ep

    is_ha_p_cl = cumulate_sum_reverse(is_ha_p) .+ ep

    is_m_p = is_m / sum(is_m)

    is_m_p_cr = cumsum(is_m_p) .+ ep

    is_m_p_cl = cumulate_sum_reverse(is_m_p) .+ ep

    a_p = ab / sum(ab)

    a_p_cr = cumsum(a_p) .+ ep

    a_p_cl = cumulate_sum_reverse(a_p) .+ ep

    a_h = ab .* is_h

    a_h_p = a_h / sum(a_h)

    a_h_p_cr = cumsum(a_h_p) .+ ep

    a_h_p_cl = cumulate_sum_reverse(a_h_p) .+ ep

    a_m = ab .* is_m

    a_m_p = a_m / sum(a_m)

    a_m_p_cr = cumsum(a_m_p) .+ ep

    a_m_p_cl = cumulate_sum_reverse(a_m_p) .+ ep

    if plp

        layout = Layout(xaxis_title = "Element")

        if length(fe_) < 100

            layout =
                merge(layout, Layout(xaxis_tickvals = 1:length(fe_), xaxis_ticktext = fe_))

        end

        display(plot_x_y([sc_]; layout = merge(layout, Layout(yaxis_title = "Score"))))

        display(
            plot_x_y(
                [is_h, is_m];
                name_ = ["Hit", "Miss"],
                layout = merge(layout, Layout(title = "Is")),
            ),
        )

        display(plot_x_y([ab]; layout = merge(layout, Layout(yaxis_title = "ab"))))

        display(
            plot_x_y(
                [is_ha_p, is_ha_p_cr, is_ha_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "Is Hit * ab")),
            ),
        )

        display(
            plot_x_y(
                [is_m_p, is_m_p_cr, is_m_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "Is Miss")),
            ),
        )

        display(
            plot_x_y(
                [a_p, a_p_cr, a_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "ab")),
            ),
        )

        display(
            plot_x_y(
                [a_h_p, a_h_p_cr, a_h_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "ab Hit")),
            ),
        )

        display(
            plot_x_y(
                [a_m_p, a_m_p_cr, a_m_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "ab Miss")),
            ),
        )

    end

    d = OrderedDict{String,Float64}()

    for (k1, hl, ml, hr, mr) in (
        ("is", is_ha_p_cl, is_m_p_cl, is_ha_p_cr, is_m_p_cr),
        ("ab", a_h_p_cl, a_m_p_cl, a_h_p_cr, a_m_p_cr),
    )

        for (k2, f1, arl_, arr_) in (
            ("ks", get_ks, [], []),
            ("ides", get_ides, [], []),
            ("ided", get_ided, [], []),
            ("idrs", get_idrs, [], []),
            ("idrd", get_idrd, [], []),
            ("idrsw", get_idrs, [a_p_cl], [a_p_cr]),
            ("idrdw", get_idrd, [a_p_cl], [a_p_cr]),
        )

            l = f1(hl, ml, arl_...)

            r = f1(hr, mr, arr_...)

            for (k3, v) in (("<", l), (">", r), ("<>", l - r))

                for (k4, f2) in (("area", get_area), ("extreme", get_extreme))

                    k = join((k1, k3, k2, k4), " ")

                    s = f2(v)

                    d[k] = s

                    if pl

                        display(plot_mountain(fe_, sc_, is_h, v, s; title = k))

                    end

                end

            end

        end

    end

    return d

end

function compare_algorithms(
    fe_::Vector{String},
    sc_::Vector{Float64},
    se_fe1_::Dict{String,Vector{String}};
    so::Bool = true,
)::Dict{String,OrderedDict{String,Float64}}

    if so

        sc_, fe_ = sort_like(sc_, fe_)

    end

    set_to_method_to_result = Dict{String,OrderedDict{String,Float64}}()

    for (set, fe1_) in se_fe1_

        set_to_method_to_result[set] =
            compare_algorithms(fe_, sc_, fe1_; so = false, plp = false, pl = false)

    end

    return set_to_method_to_result

end

export compare_algorithms
