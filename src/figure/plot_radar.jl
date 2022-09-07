function plot_radar(
    theta_,
    r__;
    name_ = _set_name(theta_),
    marker_color_ = _set_color(theta_),
    layout = Dict(),
    ou = "",
)

    data = [
        Dict(
            "type" => "scatterpolar",
            "theta" => theta,
            "r" => r_,
            "opacity" => 0.8,
            "marker" => Dict("symbol" => "diamond", "size" => 2, "color" => "#8c1515"),
            "line" => Dict("width" => 0),
            "fill" => "toself",
            "fillcolor" => "#ff1968",
        ) for (theta, r_) in zip(theta_, r__)
    ]

    axis = Dict(
        "linewidth" => 1.6,
        "linecolor" => "#48929b",
        "gridwidth" => 1.2,
        "gridcolor" => "#ebf6f7",
        "tickfont" => Dict("color" => "#1f4788"),
    )

    layout = OnePiece.dict.merge(
        Dict(
            "polar" => Dict(
                "angularaxis" => OnePiece.dict.merge(
                    axis,
                    Dict(
                        "direction" => "clockwise",
                        "tickfont" => Dict("size" => 32, "family" => "Optima"),
                    ),
                ),
                "radialaxis" => OnePiece.dict.merge(
                    axis,
                    Dict("nticks" => 8, "tickfont" => Dict("size" => 16, "family" => "Monospace")),
                ),
            ),
            "title" => Dict(
                "text" => "Radar",
                "x" => 0.01,
                "font" => Dict("size" => 48, "family" => "Times New Roman", "color" => "#27221f"),
            ),
        ),
        layout,
    )

    plot(data, layout, ou = ou)

end
