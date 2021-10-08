function sum_where(ve::Vector{Float64}, wh_::Vector{Float64})::Float64

    su = 0.0

    for ie in 1:length(ve)

        if wh_[ie] == 1.0

            su += ve[ie]

        end

    end

    return su

end

export sum_where
