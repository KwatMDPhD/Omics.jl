function _set_x(y_)

    [1:length(y) for y in y_]

end

function _set_name(y_)

    ["Name $id" for id in 1:length(y_)]

end

function _set_color(y_)

    [nothing for _ in 1:length(y_)]

end
