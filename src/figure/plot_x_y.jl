function plot_x_y(y_, x_; text_ = [], name_ = [], mode_ = [], la = Config(), ou = "")

    tr_ = make_empty_trace("scatter", length(y_))

    for (id, tr) in enumerate(tr_)

        if !isempty(name_)

            tr.name = name_[id]

        end

        tr.y = y_[id]

        tr.x = x_[id]

        if !isempty(text_)

            tr.text = text_[id]

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

        tr.mode = mode

        tr.opacity = 0.8

    end

    plot(tr_, la, ou = ou)

end

function plot_x_y(y_; ke_ar...)

    plot_y(plot_x_y, y_; ke_ar...)

end
