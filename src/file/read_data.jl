using Mmap: mmap
using CodecZlib: GzipDecompressor, transcode
using CSV: read
using DataFrames: DataFrame
using XLSX: readtable

function read_data(p::String; s::String = "")::DataFrame

    e = splitext(p)[2]

    if e == ".xlsx"

        return DataFrame(readtable(p, s)...)

    else

        v = mmap(p)

        if e == ".gz"

            v = transcode(GzipDecompressor, v)

        end

        return read(v, DataFrame)

    end

end

export read_data
