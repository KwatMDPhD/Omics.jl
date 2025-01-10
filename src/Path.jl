module Path

function shorten(pa, ro)

    pa[(lastindex(ro) + 2):end]

end

function ope(pa)

    try

        run(`open --background $pa`)

    catch

        @warn "Could not open $pa."

    end

end

end
