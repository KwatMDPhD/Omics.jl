function set_with_last!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac != va

            println("$ke (➡ $vac) ➡ $va")

        end

    end

    ke_va[ke] = va

    return nothing

end
