function write(pa::String, ta::DataFrame)::Nothing

    if !occursin(r"\.tsv$", pa)

        error("path does not end with \".tsv\"")

    end

    CSV.write(pa, ta; delim = '\t')

    return nothing

end
