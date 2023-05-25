module Array

function error_size(ar1, ar2)

    if size(ar1) != size(ar2)

        error()

    end

end

function error_size(ar_)

    for id in 1:(length(ar_) - 1)

        error_size(ar_[id], ar_[id + 1])

    end

end

function error_duplicate(ar)

    if !allunique(ar)

        error()

    end

end

end
