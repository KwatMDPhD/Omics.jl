module Matrix

using ..BioLab

function _error_size_difference(ve_)

    for id in 2:length(ve_)

        si1 = size(ve_[id - 1])

        si2 = size(ve_[id])

        if si1 != si2

            error("Array sizes differ. $si1 != $si2.")

        end

    end

end

function make(ve_)

    _error_size_difference(ve_)

    n_ro = length(ve_)

    n_co = length(ve_[1])

    ma = Base.Matrix{eltype(vcat(ve_...))}(undef, (n_ro, n_co))

    for idc in 1:n_co, idr in 1:n_ro

        ma[idr, idc] = ve_[idr][idc]

    end

    ma

end

end
