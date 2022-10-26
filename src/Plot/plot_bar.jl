function plot_bar(
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    layout = Dict(),
    ht = "",
)

    data = []

    for id in 1:length(y_)

        push!(
            data,
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ),
        )

    end

    layout = OnePiece.Dict.merge(Dict("barmode" => "stack"), layout)

    plot(data, layout, ht = ht)

end
