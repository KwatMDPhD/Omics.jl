function get_confidence_interval(co::Float64)::Tuple{Float64,Float64}

    cu = (1.0 - co) / 2.0

    return get_z_score(cu), get_z_score(1.0 - cu)

end
