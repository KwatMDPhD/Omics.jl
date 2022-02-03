function replace(st::String, _st_ne::Vector{Pair{String,String}})::String

    return reduce(Base.replace, _st_ne; init = st)

end
