function get_thermodynamic_breadth(te1, te2)

    get_kullback_leibler_divergence(te1, te2) .+ get_kullback_leibler_divergence(te2, te1)

end
