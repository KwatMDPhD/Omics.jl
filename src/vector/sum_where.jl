function sum_where(f_::Vector{Float64}, is_::Vector{Float64})::Float64

    s = 0.0

    for i = 1:length(f_)

        if is_[i] == 1.0

            s += f_[i]

        end

    end

    return s

end

export sum_where
