using JSON: json as JSON_json

function write(pa::String, di::Dict)::Int64

    println(pa)

    @assert endswith(pa, ".json")

    open(pa, "w") do io

        return Base.write(io, JSON_json(di, 2))

    end

end

export write
