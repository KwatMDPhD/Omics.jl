module Table

using CSV: read, write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

function make(n2, n1_, n2_, an)

    insertcols!(DataFrame(an, n2_), 1, n2 => n1_)

end

function rea(fi; ke_...)

    @assert isfile(fi)

    it_ = mmap(fi)

    if endswith(fi, "gz")

        it_ = transcode(GzipDecompressor, it_)

    end

    read(it_, DataFrame; ke_...)

end

function rea(xl, sh; ke_...)

    DataFrame(readtable(xl, sh; infer_eltypes = true, ke_...))

end

function writ(ts, an)

    write(ts, an; delim = '\t')

end

end
