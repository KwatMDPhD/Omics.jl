module BioLab

const _DA = joinpath(dirname(@__DIR__), "data")

const TE = joinpath(tempdir(), "BioLab")

for jl in readdir(@__DIR__)

    if !startswith(jl, '_') && jl != "BioLab.jl"

        include(jl)

    end

end

function __init__()

    if isdir(TE)

        rm(TE; recursive = true)

    end

    mkdir(TE)

end

end
