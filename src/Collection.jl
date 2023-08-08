module Collection

using StatsBase: countmap

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

# TODO: Test.
function count_sort_string(an_, fu = n -> true)

    join(("$n\t$an" for (an, n) in count_sort(an_; rev = true) if fu(n)), '\n')

end

end
