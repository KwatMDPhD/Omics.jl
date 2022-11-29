function make(an__)

    BioLab.Array.error_size(an__)

    n_ro = length(an__)

    n_co = length(an__[1])

    ro_x_co_x_an = Base.Matrix{eltype(vcat(an__...))}(undef, (n_ro, n_co))

    for idr in 1:n_ro, idc in 1:n_co

        ro_x_co_x_an[idr, idc] = an__[idr][idc]

    end

    ro_x_co_x_an

end
