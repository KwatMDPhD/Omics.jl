function get_thermodynamic_depth(ve1, ve2)

    get_kullback_leibler_divergence(ve1, ve2) .- get_kullback_leibler_divergence(ve2, ve1)

end
