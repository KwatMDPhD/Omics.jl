module DataFrame

using CSV: read as _read, write as _write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame as _DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

using ..BioLab

# TODO: Test.
function make(nar, co_, ro_an__)

    ro_ = sort!(collect(union(keys.(ro_an__)...)))

    ma = Matrix{eltype(union((values(ro_an) for ro_an in ro_an__)...))}(
        undef,
        length(ro_),
        1 + length(co_),
    )

    ma[:, 1] = ro_

    for (id2, ro_an) in enumerate(ro_an__)

        id2 += 1

        for (id1, ro) in enumerate(ro_)

            if haskey(ro_an, ro)

                an = ro_an[ro]

            else

                an = missing

            end

            ma[id1, id2] = an

        end

    end

    # TODO: Check if types are known.
    _DataFrame(ma, vcat(nar, co_))

end

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

# TODO: Check return type.
function write(ts, row_x_column_x_any)::Nothing

    _write(ts, row_x_column_x_any; delim = '\t')

end

end
