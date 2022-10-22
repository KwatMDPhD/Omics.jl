function make(ro_)

    if length(unique(length(ro) for ro in ro_)) != 1

        error()

    end

    n_ro = length(ro_)

    ro1 = ro_[1]

    n_co = length(ro1)

    ma = Base.Matrix{eltype(ro1)}(undef, n_ro, n_co)

    for idr in 1:n_ro, idc in 1:n_co

        ma[idr, idc] = ro_[idr][idc]

    end

    ma

end
