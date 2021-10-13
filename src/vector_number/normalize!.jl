function normalize!(ve::Vector{Float64}, me::String)::Nothing

    go_ = .!isnan.(ve)

    if any(go_)

        ve[go_] .= normalize(ve[go_], me)

    end

    return nothing

end

export normalize!
