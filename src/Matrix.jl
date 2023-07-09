module Matrix

using ..BioLab

function _error_size_difference(ar_)

    for id in 2:length(ar_)

        si1 = size(ar_[id - 1])

        si2 = size(ar_[id])

        if si1 != si2

            error("Array sizes differ. $si1 != $si2.")

        end

    end

end

function make(ar_)

    _error_size_difference(ar_)

    n_ro = length(ar_)

    n_co = length(ar_[1])

    ma = Base.Matrix{eltype(vcat(ar_...))}(undef, (n_ro, n_co))

    for idc in 1:n_co, idr in 1:n_ro

        ma[idr, idc] = ar_[idr][idc]

    end

    ma

end

end
