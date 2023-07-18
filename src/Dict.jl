module Dict

using JSON: parsefile as json_parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as toml_parsefile

using BioLab

function set!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            @info "($ke => $vac)."

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

            if isone(n)

                ke = "$ke.1"

            end

            pr = BioLab.String.split_get(ke, '.', 1)

            n += 1

            ke = "$pr.$n"

        end

        @warn "($kec) $ke => $va."

    end

    ke_va[ke] = va

end

function merge(ke1_va1, ke2_va2, fu = set!)

    ke1_ = keys(ke1_va1)

    ke2_ = keys(ke2_va2)

    ke_ = union(ke1_, ke2_)

    ke_va = Base.Dict{eltype(ke_), eltype(union(values(ke1_va1), values(ke2_va2)))}()

    for ke in ke_

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge(va1, va2, fu)

            else

                fu(ke_va, ke, va1)

                fu(ke_va, ke, va2)

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    ke_va

end

function read(pa, dicttype = OrderedDict; ke_ar...)

    ex = chop(splitext(pa)[2]; head = 1, tail = 0)

    if ex in ("json", "ipynb")

        json_parsefile(pa; dicttype, ke_ar...)

    elseif ex == "toml"

        toml_parsefile(pa; ke_ar...)

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
