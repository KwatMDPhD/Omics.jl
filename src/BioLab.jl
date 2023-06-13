module BioLab

const TE = joinpath(tempdir(), "BioLab")

const CA_ = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

macro is_error(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            @error er

            true

        end

    end

end

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "BioLab.jl"

        include(na)

    end

end

function __init__()

    BioLab.Path.reset(TE)

end

end
