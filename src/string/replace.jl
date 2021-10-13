using Base: replace as base_replace

function replace(st::String, _st_ne::Vector{Pair{String, String}})::String

    return reduce(base_replace, _st_ne; init = st)

end

export replace
