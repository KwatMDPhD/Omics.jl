function shift_minimum(f_::Vector{Float64}, m::Union{Float64,String})::Vector{Float64}

    if m == "0<"

        m = minimum(f_[0.0 .< f_])

    end

    return m - minimum(f_) .+ f_

end

export shift_minimum
