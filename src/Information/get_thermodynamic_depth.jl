function get_thermodynamic_depth(nu1_, nu2_)

    [
        nu2 - nu1 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end
