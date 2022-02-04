function get_z_score(cu::Float64)::Float64

    return quantile(Normal(0.0, 1.0), cu)

end
