module Collection

using StatsBase: countmap

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

# TODO: Test.
function count_sort_string(an_, n = 1)

    join(("$n\t$an" for (an, n) in count_sort(an_; rev = true) if 0 <= n), '\n')

end

end
