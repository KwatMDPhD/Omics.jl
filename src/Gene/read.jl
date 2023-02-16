function read_ensembl()

    return BioLab.Table.read(_path("ensembl.tsv.gz"))

end

function read_hgnc()

    return BioLab.Table.read(_path("hgnc_complete_set.tsv.gz"))

end
