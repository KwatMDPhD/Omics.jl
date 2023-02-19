module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as _read, write as _write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

using ..BioLab

function read(pa; xl = "", ke_ar...)

    ex = splitext(pa)[2]

    if ex == ".xlsx"

        return DataFrame(readtable(pa, xl))

    else

        it_ = mmap(pa)

        if ex == ".gz"

            it_ = transcode(GzipDecompressor, it_)

        end

        return _read(it_, DataFrame; ke_ar...)

    end

end

function write(ts, ro_x_co_x_an)

    BioLab.Path.error_extension(ts, ".tsv")

    _write(ts, ro_x_co_x_an; delim = '\t')

    return nothing

end

end
