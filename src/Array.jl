module Array

function error_size(ar1, ar2)

    si1 = size(ar1)

    si2 = size(ar2)

    if si1 != si2

        error("Array sizes, $si1 and $si2, differ.")

    end

end

function error_size(ar_)

    for id in 1:(length(ar_) - 1)

        error_size(ar_[id], ar_[id + 1])

    end

end

function error_duplicate(ar)

    if !allunique(ar)

        error("Array has duplicates.")

    end

end

end
