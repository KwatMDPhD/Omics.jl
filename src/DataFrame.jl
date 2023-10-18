module DataFrame

using CSV: read as _read, write as _write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame as _DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

using ..BioLab

function make(nar, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, nar => ro_)

end

function separate(row_x_column_x_any)

    co_ = names(row_x_column_x_any)

    id_ = 2:lastindex(co_)

    co_[1], row_x_column_x_any[:, 1], co_[id_], Matrix(row_x_column_x_any[!, id_])

end

function read(fi; ke_ar...)

    BioLab.Error.error_missing(fi)

    it_ = mmap(fi)

    if BioLab.Path.get_extension(fi) == "gz"

        it_ = transcode(GzipDecompressor, it_)

    end

    _read(it_, _DataFrame; ke_ar...)

end

function read(xl, sh; ke_ar...)

    _DataFrame(readtable(xl, sh; ke_ar...))

end

function write(ts, row_x_column_x_any)

    _write(ts, row_x_column_x_any; delim = '\t')

    nothing

end

end
