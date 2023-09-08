module Collection

using StatsBase: countmap

using ..BioLab

function range(it::AbstractArray{Int}, ::Int)

    Base.range(minimum(it), maximum(it))

end

function range(fl::AbstractArray{Float64}, n::Int)

    fl2 = view(fl, .!isnan.(fl))

    Base.range(minimum(fl2), maximum(fl2), n)

end

function unique_sort(an_, rev = false)

    sort!(unique(an_); rev)

end

function count_sort(an_, rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

function count_sort_string(an_, mi = 1)

    join(("$n $an." for (an, n) in count_sort(an_, true) if mi <= n), '\n')

end

function map_index(un_)

    BioLab.Error.error_duplicate(un_)

    Dict(un => id for (id, un) in enumerate(un_))

end

end
