function _cumulate(nu_)

    n = length(nu_)

    su = sum(nu_)

    ri_ = Vector{Float64}(undef, n)

    le_ = Vector{Float64}(undef, n)

    ri_[1] = nu_[1]

    le_[1] = su

    @inbounds @fastmath @simd for id in 1:(n - 1)

        idn = id + 1

        ri_[idn] = ri_[id] + nu_[idn]

        le_[idn] = le_[id] - nu_[id]

    end

    ri_ / su, le_ / su

end
