function set!(di, (ke, va), ho = "first"; pr = true)

    if ho == "first"

        if haskey(di, ke)

            cu = di[ke]

            if cu != va

                if pr

                    println("$ke => $cu (=> $va)")

                end

            end

        else

            di[ke] = va

        end

    elseif ho == "last"

        if haskey(di, ke)

            cu = di[ke]

            if cu != va

                if pr

                    println("$ke (=> $cu) => $va")

                end

            end

        end

        di[ke] = va

    elseif ho == "suffix"

        if haskey(di, ke)

            cu = ke

            n_du = 1

            while haskey(di, ke)

                if n_du == 1

                    ke = "$ke.1"

                end

                ke = replace(ke, Regex(".$n_du\$") => ".$(n_du+=1)")

            end

            if pr

                println("($cu =>) $ke => $va")

            end

        end

        di[ke] = va

    end

end
