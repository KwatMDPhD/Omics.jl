function set!(di, (ke, va); pr = true)

    cu = get!(di, ke, va)

    if cu != va

        if pr

            println("$ke => $cu (=> $va)")

        end

    end

end
