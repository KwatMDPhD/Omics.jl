function get_z_score(cu)

    return quantile(Normal(0.0, 1.0), cu)

end
