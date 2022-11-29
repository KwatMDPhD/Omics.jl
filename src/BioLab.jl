module BioLab

#
for pa in readdir(@__DIR__, join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

#
function __init__()

    #
    const global TE = BioLab.Path.make_temporary("BioLab")

    #
    ENV["LINES"] = 19

    ENV["COLUMNS"] = 10^5

end

end
