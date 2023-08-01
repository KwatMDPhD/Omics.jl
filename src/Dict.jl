module Dict

using JSON: parsefile as json_parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as toml_parsefile

using BioLab

function set_with_suffix!(ke_va, ke, va)

    if haskey(ke_va, ke)

        n = 1

        while haskey(ke_va, ke)

            if isone(n)

                ke = "$ke.1"

            end

            pr = BioLab.String.split_get(ke, '.', 1)

            n += 1

            ke = "$pr.$n"

        end

    end

    ke_va[ke] = va

end

function merge_recursively(ke1_va1, ke2_va2)

    ke1_ = keys(ke1_va1)

    ke2_ = keys(ke2_va2)

    ke_ = union(ke1_, ke2_)

    ke_va = Base.Dict{eltype(ke_), eltype(union(values(ke1_va1), values(ke2_va2)))}()

    for ke in ke_

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va2 = ke2_va2[ke]

            if va1 isa AbstractDict && va2 isa AbstractDict

                ke_va[ke] = merge_recursively(va1, va2)

            else

                ke_va[ke] = va2

            end

        elseif haskey(ke1_va1, ke)

            ke_va[ke] = ke1_va1[ke]

        else

            ke_va[ke] = ke2_va2[ke]

        end

    end

    ke_va

end

function is_in(an_id, an1_)

    is_ = falses(length(an_id))

    for an1 in an1_

        id = get(an_id, an1, nothing)

        if !isnothing(id)

            is_[id] = true

        end

    end

    is_

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

    js

end

end
