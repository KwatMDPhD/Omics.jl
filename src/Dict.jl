module Dict

using JSON: parse, print as JSON_print

using OrderedCollections: OrderedDict

using TOML: parsefile

using ..BioLab

function print(ke_va; so = true, n = length(ke_va))

    n_ke = length(keys(ke_va))

    n_va = length(unique(values(ke_va)))

    println(
        "$n_ke $(BioLab.String.count_noun(n_ke, "key")) ➡️ $n_va unique $(BioLab.String.count_noun(n_va, "value"))",
    )

    if so

        ke_va = sort(OrderedDict(ke_va))

    end

    display(typeof(ke_va)(collect(ke_va)[1:n]))

    if n < length(ke_va)

        println("  ...")

    end

    return nothing

end

function set_with_first!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac != va

            println("$ke ➡️ $vac (➡️ $va)")

        end

    else

        ke_va[ke] = va

    end

    return nothing

end

end
