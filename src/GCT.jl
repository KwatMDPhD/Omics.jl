module GCT

using ..BioLab

function read(gc)

    BioLab.Table.read(gc; header = 3, delim = '\t', drop = ["Description"])

end

end
