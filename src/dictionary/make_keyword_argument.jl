function make_keyword_argument(di::Dict{String, Any})::Dict{Symbol, Any}

    return Dict(Symbol(ke) => va for (ke, va) in di)

end

export make_keyword_argument
