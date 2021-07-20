function sum_h_absolute_and_n_m(
    v::Vector{Float64},
    is_::Vector{Float64},
)::Tuple{Float64,Float64}

    h = 0.0

    m = 0.0

    for i = 1:length(v)

        if is_[i] == 1.0

            f = v[i]

            if f < 0.0

                f = abs(f)

            end

            h += f

        else

            m += 1.0

        end

    end

    return h, m

end

export sum_h_absolute_and_n_m
