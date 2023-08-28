module Collection

using StatsBase: countmap

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

function count_sort_string(an_; mi = 1)

    join((string(n, '\t', an) for (an, n) in count_sort(an_; rev = true) if mi <= n), '\n')

end

end
