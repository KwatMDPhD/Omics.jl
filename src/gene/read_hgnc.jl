function read_hgnc()

    return read(joinpath(@__DIR__, "hgnc_complete_set.tsv.gz"))

end
