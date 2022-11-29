module BioLab

#
for pa in readdir(@__DIR__, join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

#
const TE = BioLab.Path.make_temporary("BioLab")

#
ENV["LINES"] = 19

ENV["COLUMNS"] = 10^5

end
