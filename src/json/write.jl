using JSON: json as JSONjson
using Base: write as Basewrite

function write(pa::String, an::Any)::Int64

    println(pa)
    @assert endswith(pa, ".json")

    open(pa, "w") do io

        Basewrite(io, JSONjson(an, 2))

    end

end

export write
