module Array

function error_duplicate(ar)

    if !allunique(ar)

        error("There is a duplicate; $(BioLab.Collection.count_sort(ar)).")

    end

end

function error_no_change(ar)

    if allequal(ar)

        error("There is no change; there is only $(ar[1]).")

    end

end

function error_size_difference(ar_)

    n = length(ar_)

    if n == 1

        @warn "There are fewer than two arrays."

    else

        for id in 1:(n - 1)

            si1 = size(ar_[id])

            si2 = size(ar_[id + 1])

            if si1 != si2

                error("There is a size difference; $si1 != $si2.")

            end

        end

    end

end

end
