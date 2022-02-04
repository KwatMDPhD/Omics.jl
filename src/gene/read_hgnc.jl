function read_hgnc()::DataFrame

    return TableAccess.read(joinpath(DA, "hgnc_complete_set.tsv.gz"))

end
