module BioLab

const DA = joinpath(dirname(@__DIR__), "data")

# TODO: Make unique with time or randomness.
const TE = joinpath(tempdir(), "BioLab")

foreach(include, (jl for jl in readdir(@__DIR__) if !startswith(jl, '_') && jl != "BioLab.jl"))

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

function __init__()

    BioLab.Path.make_directory(TE)

end

end
