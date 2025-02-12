module Path

function shorten(pa, ro)

    pa[(lastindex(ro) + 2):end]

end

function wait(pa, ma = 4; sl = 1)

    us = 0

    while us < ma && !ispath(pa)

        sleep(sl)

        @info "Waiting for $pa ($(us += sl) / $ma)"

    end

end

function ope(pa)

    try

        run(`open --background $pa`)

    catch

        @warn pa

    end

end

end
