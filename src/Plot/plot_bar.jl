function plot_bar(
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    layout = Dict(),
    ht = "",
)

    plot(
        [
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ) for id in 1:length(y_)
        ],
        BioinformaticsCore.Dict.merge(Dict("barmode" => "stack"), layout),
        ht = ht,
    )

end
