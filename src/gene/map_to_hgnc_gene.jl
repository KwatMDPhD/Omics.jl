function map_to_hgnc_gene()

    return map_to_column(read_hgnc(), ["alias_symbol", "prev_symbol", "symbol"])

end
