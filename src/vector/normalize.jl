using Statistics
using StatsBase

function normalize(f_::Vector{Float64}, m::String)::Vector{Float64}

    f_ = copy(f_)

    is_ = .!isnan.(f_)

    if any(is_)

        f_[is_] .= _normalize(f_[is_], m)

    end

    return f_

end

export normalize
