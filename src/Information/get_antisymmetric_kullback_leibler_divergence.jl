function get_antisymmetric_kullback_leibler_divergence(nu1_, nu2_, nu_; we1 = 1 / 2, we2 = 1 / 2)

    [
        nu1 * we1 - nu2 * we2 for (nu1, nu2) in
        zip(get_kullback_leibler_divergence(nu1_, nu_), get_kullback_leibler_divergence(nu2_, nu_))
    ]

end
