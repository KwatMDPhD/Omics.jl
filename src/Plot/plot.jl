function plot(data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ht = "")

    axis = Dict("automargin" => true)

    di = "BioLab.Plot.plot.$(BioLab.Time.stamp())"

    return BioLab.HTML.write(
        di,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        """
        Plotly.newPlot(
            "$di",
            $(write(data)),
            $(write(BioLab.Dict.merge(
                Dict("hovermode" => "closest", "yaxis" => axis, "xaxis" => axis),
                layout,
                BioLab.Dict.set_with_last!,
            ))),
            $(write(BioLab.Dict.merge(
                Dict(
                    "modebarbuttonstoremove" => ("select", "lasso", "resetscale"),
                    "displaylogo" => false,
                    "responsive" => true,
                    "editable" => false,
                ),
                config,
                BioLab.Dict.set_with_last!,
            ))),
        )
        """;
        ht,
    )

end
