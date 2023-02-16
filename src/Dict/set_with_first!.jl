function set_with_first!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac != va

            println("$ke ➡ $vac (➡ $va)")

        end

    else

        ke_va[ke] = va

    end

    return nothing

end
