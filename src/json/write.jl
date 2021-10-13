using Base: write as base_write
using JSON: json as json_json

function write(pa::String, di::Dict)::Int64

    println(pa)

    @assert endswith(pa, ".json")

    open(pa, "w") do io

        return base_write(io, json_json(di, 2))

    end

end

export write
