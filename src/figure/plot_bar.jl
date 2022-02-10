function plot_bar(y_, x_; name_ = [], marker_color_ = [], la = Config())

    tr_ = make_empty_trace("bar", length(y_))

    for (id, tr) in enumerate(tr_)

        if !isempty(name_)

            tr.name = name_[id]

        end

        tr.y = y_[id]

        tr.x = x_[id]

        if !isempty(marker_color_)

            tr.marker.color = marker_color_[id]

        end

        tr.opacity = 0.8

    end

    plot(tr_, la)

end

function plot_bar(y_; ke_ar...)

    plot_y(plot_bar, y_; ke_ar...)

end
