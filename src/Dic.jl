module Dic

using JSON: parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as parsefil

function index(an_)

    # TODO: Test
    an_id = OrderedDict{eltype(an_), UInt}()

    id = 0

    for an in an_

        if !haskey(an_id, an)

            an_id[an] = id += 1

        end

    end

    an_id

end

function merg(k1_v1, k2_v2)

    ke_va = Dict{
        Union{eltype(keys(k1_v1)), eltype(keys(k2_v2))},
        Union{eltype(values(k1_v1)), eltype(values(k2_v2))},
    }()

    for ke in union(keys(k1_v1), keys(k2_v2))

        ke_va[ke] = if haskey(k1_v1, ke) && haskey(k2_v2, ke)

            v1 = k1_v1[ke]

            v2 = k2_v2[ke]

            v1 isa AbstractDict && v2 isa AbstractDict ? merg(v1, v2) : v2

        elseif haskey(k1_v1, ke)

            k1_v1[ke]

        else

            k2_v2[ke]

        end

    end

    ke_va

end

function rea(fi, dicttype = OrderedDict)

    endswith(fi, ".toml") ? parsefil(fi) : parsefile(fi; dicttype)

end

function writ(js, ke_va, id = 2)

    open(js, "w") do io

        print(io, ke_va, id)

    end

    js

end

end
