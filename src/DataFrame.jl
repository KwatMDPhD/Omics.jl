module DataFrame

using CSV: read as _read, write as _write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: AbstractDataFrame, DataFrame as _DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

using ..Nucleus

function make(nr, ro_, co_, rc)

    insertcols!(_DataFrame(rc, co_), 1, nr => ro_)

end

function separate(da::AbstractDataFrame)

    co_ = names(da)

    ic_ = 2:lastindex(co_)

    co_[1], da[:, 1], co_[ic_], Matrix(da[!, ic_])

end

function read(fi; ke_ar...)

    Nucleus.Error.error_missing(fi)

    it_ = mmap(fi)

    if splitext(fi)[2] == ".gz"

        it_ = transcode(GzipDecompressor, it_)

    end

    _read(it_, _DataFrame; ke_ar...)

end

function read(xl, sh; ke_ar...)

    _DataFrame(readtable(xl, sh; ke_ar...))

end

function write(ts, da)

    _write(Nucleus.Path.clean(ts), da; delim = '\t')

    nothing

end

function separate(ar_...; ke_ar...)

    separate(read(ar_...; ke_ar...))

end

function write(ts, nr, ro_, co_, rc)

    write(ts, make(nr, ro_, co_, rc))

end

end
