module Table

using CSV: read, write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

function make(na, ro_, co_, ma)

    insertcols!(DataFrame(ma, co_), 1, na => ro_)

end

function rea(fi; ke_ar...)

    if !isfile(fi)

        error()

    end

    it_ = mmap(fi)

    if endswith(fi, ".gz")

        it_ = transcode(GzipDecompressor, it_)

    end

    read(it_, DataFrame; ke_ar...)

end

function rea(xl, sh; ke_ar...)

    DataFrame(readtable(xl, sh; ke_ar...))

end

function writ(ts, da)

    write(ts, da; delim = '\t')

end

end
