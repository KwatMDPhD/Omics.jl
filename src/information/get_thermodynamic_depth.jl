function get_thermodynamic_depth(te1, te2)

    get_kullback_leibler_divergence(te1, te2) .- get_kullback_leibler_divergence(te2, te1)

end
