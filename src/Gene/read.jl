function read_ensembl()

    BioLab.Table.read(_path("ensembl.tsv.gz"))

end

function read_hgnc()

    BioLab.Table.read(_path("hgnc_complete_set.tsv.gz"))

end
