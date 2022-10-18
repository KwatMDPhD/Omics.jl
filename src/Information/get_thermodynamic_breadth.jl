function get_thermodynamic_breadth(ve1, ve2)

    get_kullback_leibler_divergence(ve1, ve2) .+ get_kullback_leibler_divergence(ve2, ve1)

end
