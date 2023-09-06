module Collection

using StatsBase: countmap

using ..BioLab

# TODO: Test.
function unique_sort(an_)

    sort!(unique(an_))

end

# TODO: Test.
function _map_index(un_)

    BioLab.Error.error_duplicate(un_)

    Dict(un => id for (id, un) in enumerate(un_))

end

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

function count_sort_string(an_; mi = 1)

    join(("$n $an." for (an, n) in count_sort(an_; rev = true) if mi <= n), '\n')

end

end
