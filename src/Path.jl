module Path

function ope(pa)

    try

        run(`open --background $pa`)

    catch

        @warn "Could not open $pa."

    end

end

end
