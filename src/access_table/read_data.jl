function read_data(p::String; s::String = "")::DataFrame

    e = splitext(p)[2]

    if e == ".xlsx"

        return DataFrame(XLSX.readtable(p, s)...)

    else

        v = mmap(p)

        if e == ".gz"

            v = transcode(GzipDecompressor, v)

        end

        return read(v, DataFrame)

    end

end
