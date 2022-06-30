function plot_x_y(
    y_,
    x_ = [1:length(y) for y in y_];
    text_ = [],
    name_ = [],
    mode_ = [],
    la = Dict(),
    ou = "",
)

    tr_ = _make_empty_trace("scatter", length(y_))

    for (id, tr) in enumerate(tr_)

        if !isempty(name_)

            tr["name"] = name_[id]

        end

        tr["y"] = y_[id]

        tr["x"] = x_[id]

        if !isempty(text_)

            tr["text"] = text_[id]

        end

        if isempty(mode_)

            if length(x_[id]) < 1000

                mode = "markers+lines"

            else

                mode = "lines"

            end

        else

            mode = mode_[id]

        end

        tr["mode"] = mode

        tr["opacity"] = 0.8

    end

    plot(tr_, la, ou = ou)

end
