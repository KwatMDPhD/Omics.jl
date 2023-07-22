module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as _read, write as _write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

using BioLab

function read(fi; xl = "", ke_ar...)

    ex = chop(splitext(fi)[2]; head = 1, tail = 0)

    if ex == "xlsx"

        DataFrame(readtable(fi, xl))

    else

        BioLab.Path.error_missing(fi)

        it_ = mmap(fi)

        if ex == "gz"

            it_ = transcode(GzipDecompressor, it_)

        end

        _read(it_, DataFrame; ke_ar...)

    end

end

function write(ts, da)

    _write(ts, da; delim = '\t')

end

end
