function write(pa::String, di::Union{Dict,OrderedDict}; id::Int64 = 4)::Nothing

    if !occursin(r"\.json$", pa)

        error("path does not end with \".json\"")

    end

    open(pa, "w") do io

        return JSON.print(io, di, id)

    end

    return nothing

end
