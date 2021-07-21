using Statistics
using StatsBase

function normalize!(ve::Vector{Float64}, me::String)::Nothing

    bo_ = .!isnan.(ve)

    if any(bo_)

        ve[bo_] .= normalize(ve[bo_], me)

    end

    return nothing

end

export normalize!
