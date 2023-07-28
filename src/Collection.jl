module Collection

using StatsBase: countmap

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

end
