using Test

using BioLab

macro check_error(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            println(er)

            true

        end

    end

end
