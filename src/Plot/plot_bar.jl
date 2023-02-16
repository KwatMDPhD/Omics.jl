function plot_bar(
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    layout = Dict{String, Any}(),
    ht = "",
)

    return plot(
        [
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("barmode" => "stack"), layout, BioLab.Dict.merge.set_with_last!);
        ht,
    )

end
