function plot_radar(
    theta_,
    r__;
    name_ = _set_name(theta_),
    marker_color_ = _set_color(theta_),
    layout = Dict{String, Any}(),
    ht = "",
)

    axis = Dict(
        "linewidth" => 1.6,
        "linecolor" => "#48929b",
        "gridwidth" => 1.2,
        "gridcolor" => "#ebf6f7",
        "tickfont" => Dict("color" => "#1f4788"),
    )

    return plot(
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name,
                "theta" => theta,
                "r" => r_,
                "opacity" => 0.64,
                "marker" => Dict("symbol" => "diamond", "size" => 2.0, "color" => marker_color),
                "line" => Dict("width" => 0.0),
                "fill" => "toself",
                "fillcolor" => marker_color,
            ) for (theta, r_, name, marker_color) in zip(theta_, r__, name_, marker_color_)
        ],
        BioLab.Dict.merge(
            Dict(
                "polar" => Dict(
                    "angularaxis" => BioLab.Dict.merge(
                        axis,
                        Dict(
                            "direction" => "clockwise",
                            "tickfont" => Dict("size" => 32.0, "family" => "Optima"),
                        ),
                        BioLab.Dict.set_with_last!,
                    ),
                    "radialaxis" => BioLab.Dict.merge(
                        axis,
                        Dict(
                            "nticks" => 8,
                            "tickfont" => Dict("size" => 16.0, "family" => "Monospace"),
                        ),
                        BioLab.Dict.set_with_last!,
                    ),
                ),
                "title" => Dict(
                    "text" => "Radar",
                    "x" => 0.01,
                    "font" => Dict(
                        "size" => 48.0,
                        "family" => "Times New Roman",
                        "color" => "#27221f",
                    ),
                ),
            ),
            layout,
            BioLab.Dict.set_with_last!,
        );
        ht,
    )

end
