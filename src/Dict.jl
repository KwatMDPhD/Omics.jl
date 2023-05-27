module Dict

using JSON: parse, print as _print

using TOML: parsefile

using ..BioLab

function print(ke_va; n = length(ke_va))

    n_ke = length(ke_va)

    n_va = length(Set(values(ke_va)))

    ty = typeof(ke_va)

    println(
        "$ty ($(BioLab.String.count_noun(n_ke, "key")) => $(BioLab.String.count_noun(n_va, "unique value")))",
    )

    for (id, (ke, va)) in enumerate(ke_va)

        if n < id

            println("  ", "...")

            break

        end

        println("  ", ke => va)

    end

end

function set_with_first!(ke_va, ke, va; pr = true)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            BioLab.check_print(pr, "($ke => $va).")

        else

            BioLab.check_print(pr, "$ke => $vac ($va).")

        end

    else

        ke_va[ke] = va

    end

end

function set_with_last!(ke_va, ke, va; pr = true)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            BioLab.check_print(pr, "($ke => $va).")

        else

            BioLab.check_print(pr, "$ke => ($vac) $va.")

            ke_va[ke] = va

        end

    else

        ke_va[ke] = va

    end

end

function set_with_suffix!(ke_va, ke, va; pr = true)

    if haskey(ke_va, ke)

        kec = ke

        n = 1

        while haskey(ke_va, ke)

            if n == 1

                ke = "$ke.1"

            end

            ke = "$(split(ke, '.')[1]).$(n+=1)"

        end

        BioLab.check_print(pr, "($kec) $ke => $va.")

    end

    ke_va[ke] = va

end

function merge(ke1_va1, ke2_va2, fu!; pr = true)

    ke_va = Base.Dict()

    for ke in union(keys(ke1_va1), keys(ke2_va2))

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge(va1, va2, fu!; pr)

            else

                fu!(ke_va, ke, va1; pr)

                fu!(ke_va, ke, va2; pr)

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    ke_va

end

function merge(ke1_va1, ke2_va2; pr = true)

    merge(ke1_va1, ke2_va2, set_with_last!; pr)

end

function read(pa::AbstractString)

    ex = splitext(pa)[2]

    if ex in (".json", ".ipynb")

        parse(open(pa))

    elseif ex == ".toml"

        parsefile(pa)

    else

        error()

    end

end

function read(pa_)

    ke_va = Base.Dict()

    for pa in pa_

        ke_va = merge(ke_va, read(pa))

    end

    ke_va

end

function write(js, ke_va; id = 2)

    open(js, "w") do io

        _print(io, ke_va, id)

    end

end

end
