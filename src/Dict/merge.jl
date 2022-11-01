function merge(ke1_va1, ke2_va2, ho = "last")

    ke_va = Base.Dict()

    for ke in union(keys(ke1_va1), keys(ke2_va2))

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                va = merge(va1, va2)

            else

                if va1 == va2

                    va = va1

                elseif ho == "first"

                    println("$ke => $va1 (=> $va2)")

                    va = va1

                elseif ho == "last"

                    println("$ke (=> $va1) => $va2")

                    va = va2

                else

                    error()

                end

            end

        else

            for ke_va in (ke1_va1, ke2_va2)

                if haskey(ke_va, ke)

                    va = ke_va[ke]

                end

            end

        end

        if va isa AbstractDict

            va = copy(va)

        end

        ke_va[ke] = va

    end

    ke_va

end
