module Path

function shorten(pa, di)

    pa[(lastindex(di) + 2):end]

end

function wait(pa, s1 = 4)

    s2 = 0

    while s2 < s1 && !ispath(pa)

        sleep(1)

        @info "Waiting for $pa ($(s2 += 1) / $s1)"

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
