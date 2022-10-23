function _set_x(y_)

    [1:length(y) for y in y_]

end

function _set_name(y_)

    ["Name $id" for id in 1:length(y_)]

end

function _set_color(y_)

    println([fr for fr in 0:(1 / (length(y_) - 1)):1])

    [hex(NA_CO["Plotly"][fr]) for fr in 0:(1 / (length(y_) - 1)):1]

end
