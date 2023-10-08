module BioLab

const _DA = joinpath(dirname(@__DIR__), "data")

const TE = joinpath(tempdir(), "BioLab")

for jl in readdir(@__DIR__)

    if jl != "BioLab.jl"

        include(jl)

    end

end

function __init__()

    BioLab.Path.remake_directory(TE)

end

end
