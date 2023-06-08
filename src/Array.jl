module Array

function error_size_difference(ar_)

    n = length(ar_)

    if n < 2

        @warn "There are no arrays to compare."

        return

    end

    for id in 1:(n - 1)

        si1 = size(ar_[id])

        si2 = size(ar_[id + 1])

        if si1 != si2

            error("Array sizes differ. $si1 != $si2.")

        end

    end

end

end
