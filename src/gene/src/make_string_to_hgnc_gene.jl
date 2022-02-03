function make_string_to_hgnc_gene()::Dict{String,String}

    return map_to_column(read_hgnc(), ["symbol", "alias_symbol", "prev_symbol"])

end
