module GCT

using DataFrames: DataFrame, Not

using ..BioLab

function read(gc)

    BioLab.Table.read(gc; header = 3, delim = '\t')[!, Not("Description")]

end

end
