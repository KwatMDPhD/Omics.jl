function read_ensembl(; or = "human")

    OnePiece.table.read(joinpath(@__DIR__, "ensembl.$or.tsv.gz"))

end
