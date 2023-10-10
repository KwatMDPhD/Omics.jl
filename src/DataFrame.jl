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

    id_ = 2:length(co_)

    co_[1], row_x_column_x_any[:, 1], co_[id_], Matrix(row_x_column_x_any[!, id_])

end

function read(fi, xl = ""; ke_ar...)

    if isempty(xl)

        BioLab.Error.error_missing(fi)

        it_ = mmap(fi)

        if BioLab.Path.get_extension(fi) == "gz"

            it_ = transcode(GzipDecompressor, it_)

        end

        _read(it_, _DataFrame; ke_ar...)

    else

        _DataFrame(readtable(fi, xl; ke_ar...))

    end

end

function write(ts, row_x_column_x_any)

    _write(ts, row_x_column_x_any; delim = '\t')

    nothing

end

end
