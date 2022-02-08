function plot_bar(y_, x_; name_ = [], marker_color_ = [], la = Layout())

    tr_ = fill(bar(), length(y_))

    for (id, tr) in enumerate(tr_)

        if !isempty(name_)

            tr["name"] = name_[id]

        end

        tr["y"] = y_[id]

        tr["x"] = x_[id]

        if !isempty(marker_color_)

            tr["marker_color"] = marker_color_[id]

        end

        tr["opacity"] = 0.8

    end

    return plot(tr_, la)

end

function plot_bar(y_; ke_ar...)

    return plot_bar(y_, [1:length(y) for y in y_]; ke_ar...)

end
