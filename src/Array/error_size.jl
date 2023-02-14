function error_size(ar1, ar2)

    if size(ar1) != size(ar2)

        error()

    end

    nothing

end

function error_size(ar_)

    # TODO: Speed up.
    for id in 1:(length(ar_) - 1)

        error_size(ar_[id], ar_[id + 1])

    end

    nothing

end
