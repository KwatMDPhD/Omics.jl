function _check_bad(va, ba_)

    for ba in ba_

        if isequal(va, ba)

            error("Value is $ba.")

        end

    end

end

function error_bad(ma, ty)

    n_ro, n_co = size(ma)

    for idr in 1:n_ro, idc in 1:n_co

        va = ma[idr, idc]

        if !(va isa ty)

            error("Value is not a $ty.")

        end

        if ty <: Number

            ba_ = [-Inf, Inf, NaN]

        elseif ty <: AbstractString

            ba_ = [""]

        end

        _check_bad(va, ba_)

    end

end
