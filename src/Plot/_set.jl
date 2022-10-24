function _set_x(y_)

    [1:length(y) for y in y_]

end

function _set_text(y_)

    fill([], length(y_))

end

function _set_name(y_)

    ["Name $id" for id in 1:length(y_)]

end

function _set_color(y_)

    co = NA_CH["Plotly"]

    n = length(y_) - 1

    if n == 0

        fr_ = 1:1

    else

        fr_ = 0:(1 / n):1

    end

    [hex(co[fr]) for fr in fr_]

end
