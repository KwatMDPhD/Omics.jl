function _set_x(y_)

    return [collect(eachindex(y)) for y in y_]

end

function _set_text(y_)

    return fill(Vector{String}(), length(y_))

end

function _set_name(y_)

    return ["Name $id" for id in eachindex(y_)]

end

function _set_color(y_)

    n = length(y_) - 1

    if n == 0

        nu_ = 1:1

    else

        nu_ = 0.0:(1 / n):1.0

    end

    return [color(COPO, nu) for nu in nu_]

end
