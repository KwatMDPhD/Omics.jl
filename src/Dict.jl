module Dict

using JSON: parse, print as _print

using TOML: parsefile

using ..BioLab

function print(ke_va; n = length(ke_va))

    n_ke = length(keys(ke_va))

    n_va = length(Set(values(ke_va)))

    ty = typeof(ke_va)

    println(
        "🔦 $ty with $(BioLab.String.count_noun(n_ke, "key")) ➡️ $(BioLab.String.count_noun(n_va, "value")) (unique)",
    )

    display(collect(ke_va)[1:n])

    if n < length(ke_va)

        println("  ...")

    end

    return nothing

end

function symbolize(ke_va)

    return Base.Dict{Symbol, Any}(Symbol(ke) => va for (ke, va) in ke_va)

end

function set_with_first!(ke_va, ke, va; pr = true)

    if haskey(ke_va, ke)

        if pr

            vac = ke_va[ke]

            if vac == va

                #println("👯‍♀️ $ke ➡️ $va")

            else

                println("$ke ➡️ $vac (🙅 $va)")

            end

        end

    else

        ke_va[ke] = va

    end

    return nothing

end

function set_with_last!(ke_va, ke, va; pr = true)

    if haskey(ke_va, ke) && pr

        vac = ke_va[ke]

        if vac == va

            #println("👯‍♀️ $ke ➡️ $va")

        else

            println("$ke ➡️ (🙅 $vac) $va")

        end

    end

    ke_va[ke] = va

    return nothing

end

function set_with_suffix!(ke_va, ke, va; pr = true)

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

            println("(🙋 $kec) $ke ➡️ $va")

        end

    end

    ke_va[ke] = va

    return nothing

end

function merge(ke1_va1, ke2_va2, fu; pr = true)

    ke_va = Base.Dict()

    for ke in union(keys(ke1_va1), keys(ke2_va2))

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge(va1, va2, fu; pr)

            else

                fu(ke_va, ke, va1; pr)

                fu(ke_va, ke, va2; pr)

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    return ke_va

end

function read(pa::AbstractString)::Base.Dict

    ex = splitext(pa)[2]

    if ex in (".json", ".ipynb")

        return parse(open(pa))

    elseif ex == ".toml"

        return parsefile(pa)

    else

        error()

    end

end

function read(pa_)

    ke_va = Base.Dict()

    for pa in pa_

        ke_va = merge(ke_va, read(pa), set_with_last!)

    end

    return ke_va

end

function write(js, ke_va; id = 2)

    open(js, "w") do io

        _print(io, ke_va, id)

    end

    return nothing

end

end
