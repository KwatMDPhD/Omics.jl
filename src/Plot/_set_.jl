function _set_x(y_)

    [collect(1:length(y)) for y in y_]

end

function _set_text(y_)

    fill([], length(y_))

end

function _set_name(y_)

    ["Name $id" for id in 1:length(y_)]

end

function _set_color(y_)

    n = length(y_) - 1

    if n == 0

        nu_ = 1:1

    else

        nu_ = 0.0:(1 / n):1.0

    end

    [color("plotly", nu) for nu in nu_]

end
