function read_hgnc()

    OnePiece.table.read(joinpath(@__DIR__, "hgnc_complete_set.tsv.gz"))

end
