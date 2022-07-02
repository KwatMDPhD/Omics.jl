function map_to_hgnc()

    OnePiece.dataframe.map_to_column(read_hgnc(), ["prev_symbol", "alias_symbol", "symbol"])

end
