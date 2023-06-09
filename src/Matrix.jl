module Matrix

using ..BioLab

function make(an___)

    BioLab.Array.error_size_difference(an___)

    n_ro = length(an___)

    n_co = length(an___[1])

    ro_x_co_x_an = Base.Matrix{eltype(vcat(an___...))}(undef, (n_ro, n_co))

    for idr in 1:n_ro, idc in 1:n_co

        ro_x_co_x_an[idr, idc] = an___[idr][idc]

    end

    ro_x_co_x_an

end

end
