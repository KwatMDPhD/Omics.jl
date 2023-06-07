module Array

function error_duplicate(ar)

    if !allunique(ar)

        error("Array has duplicates\n$(BioLab.Collection.count_sort(ar)).")

    end

end

function error_no_change(ar)

    if allequal(ar)

        error("Array has only $(ar[1]).")

    end

end

function error_size_difference(ar_)

    n = length(ar_)

    if n < 2

        error("Need at least two arrays.")

    end

    for id in 1:(n - 1)

        si1 = size(ar_[id])

        si2 = size(ar_[id + 1])

        if si1 != si2

            error("$si1 != $si2.")

        end

    end

end

end
