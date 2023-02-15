function _error_bad(an, ba_)

    for ba in ba_

        if isequal(an, ba)

            error()

        end

    end

    nothing

end

function error_bad(ro_x_co_x_an, ty)

    n_ro, n_co = size(ro_x_co_x_an)

    for idr in 1:n_ro, idc in 1:n_co

        an = ro_x_co_x_an[idr, idc]

        if !(an isa ty)

            error()

        end

        if ty <: Real

            ba_ = (-Inf, Inf, NaN)

        elseif ty <: AbstractString

            ba_ = ("",)

        end

        _error_bad(an, ba_)

    end

    nothing

end
