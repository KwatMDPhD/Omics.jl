function _set_mode(y_)

    [ifelse(length(y) < 1000, "markers+lines", "lines") for y in y_]

end

function plot_scatter(
    y_,
    x_ = _set_x(y_);
    text_ = fill(nothing, length(y_)),
    name_ = _set_name(y_),
    mode_ = _set_mode(y_),
    marker_color_ = _set_color(y_),
    layout = Dict(),
    ou = "",
)

    data = []

    for id in 1:length(y_)

        push!(
            data,
            Dict(
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "text" => text_[id],
                "mode" => mode_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ),
        )

    end

    plot(data, layout, ou = ou)

end
