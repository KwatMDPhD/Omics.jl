function map_to_hgnc()

    OnePiece.data_frame.map_to_column(read_hgnc(), ["prev_symbol", "alias_symbol", "symbol"])

end
