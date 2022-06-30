function plot_bar(
    y_,
    x_ = [1:length(y) for y in y_];
    name_ = [],
    marker_color_ = [],
    la = Dict(),
    ou = "",
)

    tr_ = _make_empty_trace("bar", length(y_))

    for (id, tr) in enumerate(tr_)

        if !isempty(name_)

            tr["name"] = name_[id]

        end

        tr["y"] = y_[id]

        tr["x"] = x_[id]

        if !isempty(marker_color_)

            tr["marker"] = Dict("color" => marker_color_[id])

        end

        tr["opacity"] = 0.8

    end

    plot(tr_, la, ou = ou)

end
