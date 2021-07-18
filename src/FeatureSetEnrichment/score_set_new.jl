using OrderedCollections: OrderedDict
using Plotly: Layout

include("../Information/compute_kld.jl")
include("../Information/compute_idrs.jl")
include("../Information/compute_idrd.jl")
include("../Information/compute_ides.jl")
include("../Information/compute_ided.jl")

include("../Plot/plot_x_y.jl")

include("../Support/cumulate_sum_reverse.jl")
include("../Support/get_area.jl")
include("../Support/get_extreme.jl")
include("../Support/sort_like.jl")

function compute_ks(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return v1 - v2

end

function score_set_new(
    element_::Vector{String},
    score_::Vector{Float64},
    set_element_::Vector{String};
    sort::Bool = true,
    plot_process::Bool = true,
    plot::Bool = true,
)::OrderedDict{String,Float64}

    if sort

        score_, element_ = sort_like(score_, element_)

    end

    a = abs.(score_)

    is_h = check_is(element_, set_element_)

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

    if plot_process

        layout = Layout(xaxis_title = "Element")

        if length(element_) < 100

            layout = merge(
                layout,
                Layout(xaxis_tickvals = 1:length(element_), xaxis_ticktext = element_),
            )

        end

        display(plot_x_y([score_]; layout = merge(layout, Layout(yaxis_title = "Score"))))

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

                    if plot

                        display(
                            _plot(
                                element_,
                                score_,
                                set_element_,
                                is_h,
                                v,
                                s;
                                title_text = k,
                            ),
                        )

                    end

                end

            end

        end

    end

    return d

end

function score_set_new(
    element_::Vector{String},
    score_::Vector{Float64},
    set_to_element_::Dict{String,Vector{String}};
    sort::Bool = true,
)::Dict{String,OrderedDict{String,Float64}}

    if sort

        score_, element_ = sort_like(score_, element_)

    end

    set_to_method_to_result = Dict{String,OrderedDict{String,Float64}}()

    for (set, set_element_) in set_to_element_

        set_to_method_to_result[set] =
            score_set_new(element_, score_, set_element_; sort = false, plot = false)

    end

    return set_to_method_to_result

end

export score_set_new
