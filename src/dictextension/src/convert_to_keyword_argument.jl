function convert_to_keyword_argument(di::Dict)::Dict{Symbol,Any}

    return Dict(Symbol(ke) => va for (ke, va) in di)

end
