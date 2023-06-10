module Dict

using JSON: parse, print

using TOML: parsefile

function set_with_first!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            @info "($ke => $va)."

        else

            @warn "$ke => $vac ($va)."

        end

    else

        ke_va[ke] = va

    end

end

function set_with_last!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            @info "($ke => $va)."

        else

            @warn "$ke => ($vac) $va."

            ke_va[ke] = va

        end

    else

        ke_va[ke] = va

    end

end

function set_with_suffix!(ke_va, ke, va)

    if haskey(ke_va, ke)

        kec = ke

        n = 1

        while haskey(ke_va, ke)

            if n == 1

                ke = "$ke.1"

            end

            ke = "$(split(ke, '.')[1]).$(n+=1)"

        end

        @warn "($kec) $ke => $va."

    end

    ke_va[ke] = va

end

function merge(ke1_va1, ke2_va2, fu!)

    ke_va = Base.Dict()

    for ke in union(keys(ke1_va1), keys(ke2_va2))

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge(va1, va2, fu!)

            else

                fu!(ke_va, ke, va1)

                fu!(ke_va, ke, va2)

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    ke_va

end

function merge(ke1_va1, ke2_va2)

    merge(ke1_va1, ke2_va2, set_with_last!)

end

function read(pa)

    ex = splitext(pa)[2][2:end]

    if ex in ("json", "ipynb")

        parse(open(pa))

    elseif ex == "toml"

        parsefile(pa)

    else

        error("Can not read a $ex.")

    end

end

function write(js, ke_va; id = 2)

    open(js, "w") do io

        print(io, ke_va, id)

    end

end

end
