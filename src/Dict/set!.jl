# TODO: Use merge
function set!(ke_va, (ke, va), ho = "first"; pr = true)

    if ho == "first"

        if haskey(ke_va, ke)

            vac = ke_va[ke]

            if pr && vac != va

                println("$ke => $vac (=> $va)")

            end

        else

            ke_va[ke] = va

        end

    elseif ho == "last"

        if haskey(ke_va, ke)

            vac = ke_va[ke]

            if pr && vac != va

                println("$ke (=> $vac) => $va")

            end

        end

        ke_va[ke] = va

    elseif ho == "suffix"

        if haskey(ke_va, ke)

            kec = ke

            n = 1

            while haskey(ke_va, ke)

                if n == 1

                    ke = "$ke.1"

                end

                ke = replace(ke, Regex(".$n\$") => ".$(n+=1)")

            end

            if pr

                println("($kec =>) $ke => $va")

            end

        end

        ke_va[ke] = va

    else

        error()

    end

    nothing

end
