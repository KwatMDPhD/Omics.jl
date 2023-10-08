module Dict

using JSON: parsefile as json_parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as toml_parsefile

using ..BioLab

function set_with_suffix!(ke_va, ke, va)

    n = 1

    while haskey(ke_va, ke)

        if isone(n)

            pr = ke

        else

            pr = rsplit(ke, '.'; limit = 2)[1]

        end

        ke = "$pr.$(n += 1)"

    end

    ke_va[ke] = va

    nothing

end

function merge(ke1_va1, ke2_va2)

    ke_ = union(keys(ke1_va1), keys(ke2_va2))

    ke_va = Base.Dict{eltype(ke_), eltype(union(values(ke1_va1), values(ke2_va2)))}()

    for ke in ke_

        if haskey(ke1_va1, ke) && haskey(ke2_va2, ke)

            va1 = ke1_va1[ke]

            va = ke2_va2[ke]

            if va1 isa AbstractDict && va isa AbstractDict

                va = merge(va1, va)

            end

        elseif haskey(ke1_va1, ke)

            va = ke1_va1[ke]

        else

            va = ke2_va2[ke]

        end

        ke_va[ke] = va

    end

    ke_va

end

function is_in(an_id, an1_)

    is_ = falses(length(an_id))

    for an1 in an1_

        # TODO: Benchmark `missing` and `haskey`.
        id = get(an_id, an1, nothing)

        if !isnothing(id)

            is_[id] = true

        end

    end

    is_

end

function read(fi, dicttype = OrderedDict; ke_ar...)

    ex = BioLab.Path.get_extension(fi)

    if ex in ("json", "ipynb")

        json_parsefile(fi; dicttype, ke_ar...)

    elseif ex == "toml"

        toml_parsefile(fi; ke_ar...)

    else

        error("`$ex` is not `json`, `ipynb`, or `toml`.")

    end

end

# TODO: Check return type.
function write(js, ke_va, id = 2)::Nothing

    open(js, "w") do io

        print(io, ke_va, id)

    end

end

end
