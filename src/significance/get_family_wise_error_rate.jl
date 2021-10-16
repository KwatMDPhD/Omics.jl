function get_family_wise_error_rate(n_te::Int64, er::Float64 = 0.05)::Float64

    return 1 - (1 - er)^n_te

end

export get_family_wise_error_rate
