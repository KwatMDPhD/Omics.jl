module Path

function shorten(pa, di)

    pa[(lastindex(di) + 2):end]

end

function wai(pa, u1 = 4)

    u2 = 0

    while u2 < u1 && !ispath(pa)

        sleep(1)

        @info "Waiting for $pa ($(u2 += 1) / $u1)"

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
