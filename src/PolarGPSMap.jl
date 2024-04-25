module PolarGPSMap

using ..Nucleus

function plot(
    ht,
    no_,
    di_x_no_x_co,
    po_,
    di_x_po_x_co;
    node_marker_size = 32,
    node_marker_opacity = 0.96,
    node_marker_color = "#171412",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    node_annotation_font_size = 16,
    node_annotation_font_color = node_marker_color,
    node_annotation_bgcolor = "#ffffff",
    node_annotation_borderpad = 2,
    node_annotation_borderwidth = node_marker_line_width,
    node_annotation_bordercolor = node_marker_line_color,
    node_annotation_arrowwidth = 1.6,
    node_annotation_arrowcolor = node_marker_line_color,
    n_gr = 64,
    ncontours = 32,
    point_marker_size = 16,
    point_marker_opacity = 0.64,
    point_marker_color = Nucleus.Color.HEGE,
    point_marker_line_width = 0.8,
    point_marker_line_color = "#000000",
    sc_ = nothing,
    sc_na = Dict{Int, String}(),
    layout = Dict{String, Any}(),
)

    data = Dict{String, Any}[]

    push!(
        data,
        Dict(
            "y" => (0,),
            "x" => (0,),
            "mode" => "markers",
            "marker" => Dict(
                "size" => 696,
                "color" => Nucleus.Color.add_alpha("#000000", 0.04),
                "line" => Dict("width" => 4, "color" => Nucleus.Color.HEIP),
            ),
        ),
    )

    push!(
        data,
        Dict(
            "y" => di_x_no_x_co[1, :],
            "x" => di_x_no_x_co[2, :],
            "text" => no_,
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => node_marker_size,
                "color" => node_marker_color,
                "line" =>
                    Dict("width" => node_marker_line_width, "color" => node_marker_line_color),
                "opacity" => node_marker_opacity,
            ),
            "textfont" => Dict(
                "family" => "Gravitas One, monospace",
                "size" => node_annotation_font_size,
                "color" => "#ffffff",
            ),
        ),
    )

    point = Dict(
        "y" => view(di_x_po_x_co, 1, :),
        "x" => view(di_x_po_x_co, 2, :),
        "text" => po_,
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "color" => point_marker_color,
            "line" => Dict("width" => point_marker_line_width, "color" => point_marker_line_color),
            "opacity" => point_marker_opacity,
        ),
    )

    # TODO
    if true || isnothing(sc_)

        push!(data, point)

    end

    axis = Dict(
    #"showgrid" => false,
    #"zeroline" => false,
    #"showticklabels" => false,
    )

    margin = 24

    range = 1.08

    Nucleus.Plot.plot(
        ht,
        data,
        Nucleus.Dict.merge(
            Dict(
                "height" => 800,
                "width" => 800,
                "margin" => Dict("t" => margin, "b" => margin, "l" => margin, "r" => margin),
                "yaxis" => merge(axis, Dict("range" => (range, -range))),
                "xaxis" => merge(axis, Dict("range" => (-range, range))),
                "showlegend" => false,
            ),
            layout,
        ),
    )

end

end
