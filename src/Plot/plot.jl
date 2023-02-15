function plot(data, layout = Dict(); config = Dict(), ht = "")

    axis = Dict("automargin" => true)

    di = "BioLab.Plot.plot.$(BioLab.Time.stamp())"

    return BioLab.HTML.write(
        di,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        """
        Plotly.newPlot(
            \"$di\",
            $(write(data)),
            $(write(BioLab.Dict.merge(
                Dict("hovermode" => "closest", "yaxis" => axis, "xaxis" => axis),
                layout,
                "last",
            ))),
            $(write(BioLab.Dict.merge(
                Dict(
                    "modebarbuttonstoremove" => ("select", "lasso", "resetscale"),
                    "displaylogo" => false,
                    "responsive" => true,
                    "editable" => false,
                ),
                config,

                "last",
            ))),
        )
        """;
        ht,
    )

end
