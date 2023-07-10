module GCT

using BioLab

function read(gc)

    BioLab.Table.read(gc; header = 3, drop = ["Description"])

end

end
