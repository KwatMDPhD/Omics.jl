module Coordinate

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function get(an_x_an_x_di, maxoutdim = 2)

    fit(MetricMDS, an_x_an_x_di; distances = true, maxoutdim, maxiter = 10^3).X

end

function pull(di_x_no_x_co, no_x_po_x_pu)

    no_x_po_x_pu = copy(no_x_po_x_pu)

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(no_x_po_x_pu))

    di_x_no_x_co * no_x_po_x_pu

end

function trace!(
    data,
    an_,
    di_x_an_x_co,
    marker_size,
    marker_opacity,
    marker_color,
    marker_line_width,
    marker_line_color,
)

    push!(
        data,
        Dict(
            "y" => view(di_x_an_x_co, 1, :),
            "x" => view(di_x_an_x_co, 2, :),
            "text" => an_,
            "mode" => "markers",
            "marker" => Dict(
                "size" => marker_size,
                "opacity" => marker_opacity,
                "color" => marker_color,
                "line" => Dict("width" => marker_line_width, "color" => marker_line_color),
            ),
            "hoverinfo" => "text",
        ),
    )

    nothing

end

function annotate!(annotations, an_, di_x_an_x_co, font_color, width, color)

    append!(
        annotations,
        [
            Dict(
                "y" => co1,
                "x" => co2,
                "text" => "<b>$no</b>",
                "font" => Dict(
                    "family" => "Gravitas One, monospace",
                    "size" => 16,
                    "color" => font_color,
                ),
                "bgcolor" => "#ffffff",
                "borderpad" => 2,
                "borderwidth" => width,
                "bordercolor" => color,
                "arrowwidth" => width,
                "arrowcolor" => color,
            ) for (no, (co1, co2)) in zip(an_, eachcol(di_x_an_x_co))
        ],
    )

    nothing

end

end
