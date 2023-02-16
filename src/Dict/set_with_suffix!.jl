function set_with_suffix!(ke_va, ke, va)

    if haskey(ke_va, ke)

        kec = ke

        n = 1

        while haskey(ke_va, ke)

            if n == 1

                ke = "$ke.1"

            end

            replace!(ke, Regex(".$n\$") => ".$(n+=1)")

        end

        println("($kec ➡) $ke ➡ $va")

    end

    ke_va[ke] = va

    return nothing

end
