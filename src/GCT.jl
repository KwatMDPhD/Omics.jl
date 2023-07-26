module GCT

using BioLab

function read(gc)

    BioLab.DataFrame.read(gc; header = 3, drop = ["Description"])

end

end
