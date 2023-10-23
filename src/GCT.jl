module GCT

using ..Nucleus

function read(gc)

    Nucleus.DataFrame.read(gc; header = 3, drop = ["Description"])

end

end
