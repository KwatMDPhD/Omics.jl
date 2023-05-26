module Bad

function _get_bad(::Type{Float64})

    (-Inf, Inf, NaN)

end

function _get_bad(::Type{<:AbstractString})

    ("",)

end

function _get_bad(::Type)

    ()

end

function error_bad(an, ty)

    if !(an isa ty)

        error("$an is not a $ty.")

    end

    for ba in _get_bad(ty)

        if isequal(an, ba)

            error("$an is a bad $ty.")

        end

    end

end

end
