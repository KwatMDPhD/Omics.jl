module Table

using CSV: read, write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

function make(na, ro_, co_, an)

    insertcols!(DataFrame(an, co_), 1, na => ro_)

end

function rea(fi; ke_...)

    @assert isfile(fi)

    it_ = mmap(fi)

    if endswith(fi, "gz")

        it_ = transcode(GzipDecompressor, it_)

    end

    read(it_, DataFrame; ke_...)

end

function rea(fi, sh; ke_...)

    DataFrame(readtable(fi, sh; infer_eltypes = true, ke_...))

end

function writ(fi, an)

    write(fi, an; delim = '\t')

end

end
