function replace(st::String, st_ne::Pair{String,String}...)::String

    return reduce(Base.replace, st_ne; init = st)

end

export replace
