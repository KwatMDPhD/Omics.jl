function plot_histogram(
    x_,
    text_ = [];
    name_ = _set_name(x_),
    histnorm = nothing,
    xbins_size = nothing,
    marker_color_ = _set_color(x_),
    layout = Dict(),
    ou = "",
)

    ru = ~isempty(text_) && all(length.(x_) .< 1e5)

    n_hi = length(x_)

    if ru

        fr = minimum([n_hi * 0.08, 0.5])

    else

        fr = 0.0

    end

    if isnothing(histnorm)

        yaxis2_title = "N"

    else

        yaxis2_title = titlecase(histnorm)

    end

    layout = OnePiece.dict.merge(
        Dict(
            "yaxis" => Dict(
                "domain" => [0, fr],
                "zeroline" => false,
                "dtick" => 1,
                "showticklabels" => false,
            ),
            "yaxis2" => Dict("domain" => [fr, 1], "title" => Dict("text" => yaxis2_title)),
            "xaxis" => Dict("anchor" => "y"),
        ),
        layout,
    )

    data = []

    for id in 1:n_hi

        sh = Dict(
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
        )

        push!(
            data,
            OnePiece.dict.merge(
                sh,
                Dict(
                    "yaxis" => "y2",
                    "type" => "histogram",
                    "histnorm" => histnorm,
                    "xbins" => Dict("size" => xbins_size),
                ),
            ),
        )

        if ru

            push!(
                data,
                OnePiece.dict.merge(
                    sh,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" =>
                            Dict("symbol" => "line-ns-open", "size" => 16, "opacity" => 0.92),
                        "hoverinfo" => "x+text",
                    ),
                ),
            )

        end

    end

    plot(data, layout, ou = ou)

end
