module Dict

using JSON: parsefile as json_parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as toml_parsefile

using ..BioLab

function set_with_first!(ke_va, ke, va)

    if haskey(ke_va, ke)

        vac = ke_va[ke]

        if vac == va

            @info "($ke => $vac)."

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

            if n == 1

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

function merge(ke1_va1, ke2_va2, fu!)

    ke_va = Base.Dict{
        typejoin(eltype(keys(ke1_va1)), eltype(keys(ke2_va2))),
        typejoin(eltype(values(ke1_va1)), eltype(values(ke2_va2))),
    }()

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

function map(na1_na2, na1_)

    n = length(na1_)

    na2_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n1 = n2 = n3 = 0

    for (id, na1) in enumerate(na1_)

        if haskey(na1_na2, na1)

            na2 = na1_na2[na1]

            if na1 == na2

                ma = 1

                n1 += 1

            else

                ma = 2

                n2 += 1

            end

        else

            na2 = na1

            ma = 3

            n3 += 1

        end

        na2_[id] = na2

        ma_[id] = ma

    end

    @info "Already mapped $n1. Mapped $n2. Failed $n3."

    na2_, ma_

end

# TODO: Test.
function read(pa, dicttype = OrderedDict; ke_ar...)

    ex = splitext(pa)[2][2:end]

    if ex in ("json", "ipynb")

        json_parsefile(pa; dicttype, ke_ar...)

    elseif ex == "toml"

        convert(dicttype, toml_parsefile(pa; ke_ar...))

    else

        error("Can not read a $ex.")

    end

end

function write(js, ke_va; id = 2)

    BioLab.Path.warn_overwrite(js)

    BioLab.Path.error_extension_difference(js, "json")

    open(js, "w") do io

        print(io, ke_va, id)

    end

end

end
