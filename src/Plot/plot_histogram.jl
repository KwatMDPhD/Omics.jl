function plot_histogram(
    x_,
    text_ = _set_text(x_);
    name_ = _set_name(x_),
    histnorm = "",
    xbins_size = 0.0,
    marker_color_ = _set_color(x_),
    layout = Dict(),
    ht = "",
)

    #
    ru = all(length(x) < 10^5 for x in x_)

    n = length(x_)

    if ru

        fr = min(n * 0.08, 0.5)

    else

        fr = 0.0

    end

    #
    if isempty(histnorm)

        yaxis2_title = "N"

    else

        yaxis2_title = titlecase(histnorm)

    end

    #
    layout = BioinformaticsCore.Dict.merge(
        Dict(
            "yaxis" => Dict(
                "domain" => (0.0, fr),
                "zeroline" => false,
                "dtick" => 1,
                "showticklabels" => false,
            ),
            "yaxis2" => Dict("domain" => (fr, 1.0), "title" => Dict("text" => yaxis2_title)),
            "xaxis" => Dict("anchor" => "y"),
        ),
        layout,
    )

    #
    data = []

    for id in 1:n

        #
        le = Dict(
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
        )

        #
        push!(
            data,
            BioinformaticsCore.Dict.merge(
                le,
                Dict(
                    "yaxis" => "y2",
                    "type" => "histogram",
                    "histnorm" => histnorm,
                    "xbins" => Dict("size" => xbins_size),
                ),
            ),
        )

        #
        if ru

            push!(
                data,
                BioinformaticsCore.Dict.merge(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => Dict("symbol" => "line-ns-open", "size" => 16.0),
                        "hoverinfo" => "x+text",
                    ),
                ),
            )

        end

    end

    #
    plot(data, layout, ht = ht)

end
