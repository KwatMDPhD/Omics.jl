function merge(ke1_va1, ke2_va2, ho)

    ke_va = Base.Dict()

    for ke in union(keys(ke1_va1), keys(ke2_va2))

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge(va1, va2, ho)

            else

                ho(ke_va, ke, va1)

                ho(ke_va, ke, va2)

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    ke_va

end
