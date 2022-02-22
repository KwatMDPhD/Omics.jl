function map_to_hgnc_gene()

    OnePiece.dataframe.map_to_column(read_hgnc(), ["prev_symbol", "alias_symbol", "symbol"])

end
