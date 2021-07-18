function replace_multiple(s::String, p::Pair{String,String}...)::String

    return reduce(replace, p; init = s)

end

export replace_multiple
