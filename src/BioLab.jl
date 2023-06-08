module BioLab

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "BioLab.jl"

        include(na)

    end

end

const CA_ = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

const TE = joinpath(tempdir(), "BioLab")

function __init__()

    BioLab.Path.reset(TE)

end

macro is_error(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            println(er.msg)

            true

        end

    end

end

end
