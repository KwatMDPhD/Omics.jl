function convert(ro_...)

    if length(unique(length.(ro_))) != 1

        error()

    end

    n_ro = length(ro_)

    ro1 = ro_[1]

    n_co = length(ro1)

    ma = Matrix{typeof(ro1[1])}(undef, n_ro, n_co)

    @inbounds @fastmath for id1 in 1:n_ro, id2 in 1:n_co

        ma[id1, id2] = ro_[id1][id2]

    end

    ma

end
