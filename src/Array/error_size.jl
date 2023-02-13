function error_size(ar1, ar2)

    if size(ar1) != size(ar2)

        error()

    end

end

function error_size(ar_)

    reduce(error_size, ar_)

end
