function get_kullback_leibler_divergence(nu1_, nu2_)

    [nu1 * log(nu1 / nu2) for (nu1, nu2) in zip(nu1_, nu2_)]

end
