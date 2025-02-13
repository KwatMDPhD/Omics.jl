module Dic

using JSON: parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as parsefil

using ..Omics

function set_with_suffix!(di, ke, va)

    id = 1

    while haskey(di, ke)

        ke = "$(isone(id) ? ke : Omics.Strin.trim_end(ke, '.')).$(id += 1)"

    end

    di[ke] = va

end

function index(an_)

    di = Dict{eltype(an_), Vector{Int}}()

    for id in eachindex(an_)

        an = an_[id]

        if !haskey(di, an)

            di[an] = Int[]

        end

        push!(di[an], id)

    end

    di

end

function merg(d1, d2)

    d3 = Dict{
        Union{eltype(keys(d1)), eltype(keys(d2))},
        Union{eltype(values(d1)), eltype(values(d2))},
    }()

    for ke in union(keys(d1), keys(d2))

        d3[ke] = if haskey(d1, ke) && haskey(d2, ke)

            v1 = d1[ke]

            v2 = d2[ke]

            v1 isa AbstractDict && v2 isa AbstractDict ? merg(v1, v2) : v2

        elseif haskey(d1, ke)

            d1[ke]

        else

            d2[ke]

        end

    end

    d3

end

function rea(fi, dicttype = OrderedDict)

    endswith(fi, ".toml") ? parsefil(fi) : parsefile(fi; dicttype)

end

function writ(fi, di, id = 2)

    open(fi, "w") do io

        print(io, di, id)

    end

end

end
