module DataFrame

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame as _DataFrame, insertcols!

using CSV: read as _read, write as _write

using Mmap: mmap

using XLSX: readtable

using ..BioLab

function make(nar, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, nar => ro_)

end

function separate(da)

    co_ = names(da)

    id_ = 2:length(co_)

    co_[1], da[:, 1], view(co_, id_), Matrix(da[!, id_])

end

function read(fi; xl = "", ke_ar...)

    ex = chop(splitext(fi)[2]; head = 1, tail = 0)

    if ex == "xlsx"

        _DataFrame(readtable(fi, xl; ke_ar...))

    else

        BioLab.Error.error_missing(fi)

        it_ = mmap(fi)

        if ex == "gz"

            it_ = transcode(GzipDecompressor, it_)

        end

        _read(it_, _DataFrame; ke_ar...)

    end

end

function write(ts, da)

    _write(ts, da; delim = '\t')

end

end
