function plot_radar(theta, r_)

    linewidth = 1.6

    tickfont_color = "#003171"

    linecolor = "#1f4788"

    gridwidth = 1.2

    gridcolor = "#ebf6f7" #"#4d8fac"

    axis = Dict(
        "linewidth" => linewidth,
        "linecolor" => linecolor,
        "gridwidth" => gridwidth,
        "gridcolor" => gridcolor,
        "tickfont" => Dict("color" => tickfont_color),
    )

    plot(
        [
            Dict(
                "type" => "scatterpolar",
                "theta" => theta,
                "r" => r_,
                "opacity" => 0.8,
                "marker" => Dict("symbol" => "diamond", "size" => 2, "color" => "#8c1515"),
                "line" => Dict("width" => 0),
                "fill" => "toself",
                "fillcolor" => "#ff1968",
            ),
        ],
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
                    Dict("nticks" => 8, "tickfont" => Dict("size" => 24, "family" => "Monospace")),
                ),
            ),
            "title" => Dict(
                "text" => "Radar",
                "font" =>
                    Dict("size" => 56, "family" => "Times New Roman", "color" => "#27221f"),
            ),
        ),
    )

end
