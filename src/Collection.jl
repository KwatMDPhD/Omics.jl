module Collection

using StatsBase: countmap

function get_minimum_maximum(an_)

    mi = ma = an_[1]

    for id in 2:length(an_)

        an = an_[id]

        if an < mi

            mi = an

        elseif ma < an

            ma = an

        end

    end

    mi, ma

end

function count_sort_string(an_, mi = 1)

    join("$n $an.\n" for (an, n) in sort(countmap(an_); byvalue = true, rev = true) if mi <= n)

end

end
