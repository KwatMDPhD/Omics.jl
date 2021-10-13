using JSON: json as JSON_json

function write(pa::String, di::Dict)::Int64

    println(pa)

    @assert occursin(r"\.json$", pa)

    open(pa, "w") do io

        return Base.write(io, JSON_json(di, 4))

    end

end

export write
