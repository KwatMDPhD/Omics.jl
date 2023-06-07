module Array

function error_duplicate(ar)

    if !allunique(ar)

        error()

    end

end

function error_size(ar_)

    n = length(ar_)

    if n < 2

        error()

    end

    for id in 1:(n - 1)

        if size(ar_[id]) != size(ar_[id + 1])

            error()

        end

    end

end

end
