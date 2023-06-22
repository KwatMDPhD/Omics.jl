module BioLab

const DA = joinpath(dirname(@__DIR__), "data")

const TE = joinpath(tempdir(), "BioLab")

const CA_ = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

macro is_error(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            @info "Errored." er

            true

        end

    end

end

for jl in readdir(@__DIR__)

    if !startswith(jl, '_') && jl != "BioLab.jl"

        include(jl)

    end

end

function __init__()

    BioLab.Path.reset(TE)

end

end
