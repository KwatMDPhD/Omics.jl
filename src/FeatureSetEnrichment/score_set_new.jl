using OrderedCollections: OrderedDict
using Plotly: Layout

using Kwat.Information: compute_ided, compute_ides, compute_idrd, compute_idrs, compute_kld
using Kwat.Plot: plot_x_y
using Kwat.Support: cumulate_sum_reverse, get_area, get_extreme, sort_like

function compute_ks(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return v1 - v2

end

function score_set_new(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String};
    so::Bool = true,
    plp::Bool = false,
    pl::Bool = true,
    ke...,
)::OrderedDict{String,Float64}

    if so

        sc_, el_ = sort_like(sc_, el_)

    end

    a = abs.(sc_)

    is_h = check_is(el_, el1_)

    is_m = 1.0 .- is_h

    is_ha = is_h .* a

    e = eps()

    is_ha_p = is_ha / sum(is_ha)

    is_ha_p_cr = cumsum(is_ha_p) .+ e

    is_ha_p_cl = cumulate_sum_reverse(is_ha_p) .+ e

    is_m_p = is_m / sum(is_m)

    is_m_p_cr = cumsum(is_m_p) .+ e

    is_m_p_cl = cumulate_sum_reverse(is_m_p) .+ e

    a_p = a / sum(a)

    a_p_cr = cumsum(a_p) .+ e

    a_p_cl = cumulate_sum_reverse(a_p) .+ e

    a_h = a .* is_h

    a_h_p = a_h / sum(a_h)

    a_h_p_cr = cumsum(a_h_p) .+ e

    a_h_p_cl = cumulate_sum_reverse(a_h_p) .+ e

    a_m = a .* is_m

    a_m_p = a_m / sum(a_m)

    a_m_p_cr = cumsum(a_m_p) .+ e

    a_m_p_cl = cumulate_sum_reverse(a_m_p) .+ e

    if plp

        layout = Layout(xaxis_title = "Element")

        if length(el_) < 100

            layout =
                merge(layout, Layout(xaxis_tickvals = 1:length(el_), xaxis_ticktext = el_))

        end

        display(plot_x_y([sc_]; layout = merge(layout, Layout(yaxis_title = "Score"))))

        display(
            plot_x_y(
                [is_h, is_m];
                name_ = ["Hit", "Miss"],
                layout = merge(layout, Layout(title = "Is")),
            ),
        )

        display(plot_x_y([a]; layout = merge(layout, Layout(yaxis_title = "A"))))

        display(
            plot_x_y(
                [is_ha_p, is_ha_p_cr, is_ha_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "Is Hit * A")),
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
                layout = merge(layout, Layout(title = "A")),
            ),
        )

        display(
            plot_x_y(
                [a_h_p, a_h_p_cr, a_h_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "A Hit")),
            ),
        )

        display(
            plot_x_y(
                [a_m_p, a_m_p_cr, a_m_p_cl];
                name_ = ["P", "CR(P)", "CL(P)"],
                layout = merge(layout, Layout(title = "A Miss")),
            ),
        )

    end

    d = OrderedDict{String,Float64}()

    for (k1, hl, ml, hr, mr) in (
        ("is", is_ha_p_cl, is_m_p_cl, is_ha_p_cr, is_m_p_cr),
        ("a", a_h_p_cl, a_m_p_cl, a_h_p_cr, a_m_p_cr),
    )

        for (k2, f1, args) in (
            ("ks", compute_ks, ()),
            ("idrs", compute_idrs, ()),
            ("idrsw", compute_idrs, (a_p_cl,)),
            ("idrd", compute_idrd, ()),
            ("idrdw", compute_idrd, (a_p_cl,)),
            ("ides", compute_ides, ()),
            ("ided", compute_ided, ()),
        )

            l = f1(hl, ml, args...)

            r = f1(hr, mr, args...)

            for (k3, v) in (("<", l), (">", r), ("<>", l - r))

                for (k4, f2) in (("area", get_area), ("extreme", get_extreme))

                    k = join((k1, k3, k2, k4), " ")

                    if !(
                        k in (
                            "is < ks area",
                            "is <> idrd area",
                            "a <> idrd area",
                            "a <> idrdw area",
                        )
                    )

                        continue

                    end

                    s = f2(v)

                    d[k] = s

                    if pl

                        display(_plot(el_, sc_, el1_, is_h, v, s; title = k))

                    end

                end

            end

        end

    end

    return d

end

function score_set_new(
    el_::Vector{String},
    sc_::Vector{Float64},
    se_el1_::Dict{String,Vector{String}};
    so::Bool = true,
)::Dict{String,OrderedDict{String,Float64}}

    if so

        sc_, el_ = sort_like(sc_, el_)

    end

    set_to_method_to_result = Dict{String,OrderedDict{String,Float64}}()

    for (set, el1_) in se_el1_

        set_to_method_to_result[set] =
            score_set_new(el_, sc_, el1_; so = false, plp = false, pl = false)

    end

    return set_to_method_to_result

end

export score_set_new
