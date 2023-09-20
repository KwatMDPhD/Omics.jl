module DataFrame

using CSV: read as _read, write as _write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame as _DataFrame, insertcols!

using Mmap: mmap

using XLSX: readtable

using ..BioLab

function make(nar, co_, ro_an__)

    ro_ = sort!(collect(union(keys.(ro_an__)...)))

    ma = Matrix{Any}(undef, length(ro_), 1 + length(co_))

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

    _DataFrame(ma, vcat(nar, co_))

end

function make(nar, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, nar => ro_)

end

function separate(da)

    co_ = names(da)

    id_ = 2:length(co_)

    co_[1], da[:, 1], view(co_, id_), Matrix(da[!, id_])

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

function write(ts, da)

    _write(ts, da; delim = '\t')

end

end
