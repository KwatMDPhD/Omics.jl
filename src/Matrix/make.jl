function make(ro_)

    OnePiece.Array.error_size(ro_)

    n_ro = length(ro_)

    n_co = length(ro_[1])

    ma = Base.Matrix{eltype(vcat(ro_...))}(undef, n_ro, n_co)

    for idr in 1:n_ro, idc in 1:n_co

        ma[idr, idc] = ro_[idr][idc]

    end

    ma

end
