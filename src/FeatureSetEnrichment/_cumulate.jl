function _cumulate(ab_)

    n = length(ab_)

    su = sum(ab_)

    ri_ = Vector{Float64}(undef, n)

    le_ = Vector{Float64}(undef, n)

    ri_[1] = ab_[1]

    le_[1] = su

    @inbounds @fastmath @simd for id in 1:(n - 1)

        idn = id + 1

        ri_[idn] = ri_[id] + ab_[idn]

        le_[idn] = le_[id] - ab_[id]

    end

    ri_ / su, le_ / su

end
