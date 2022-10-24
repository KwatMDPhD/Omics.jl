function get_thermodynamic_breadth(nu1_, nu2_)

    [
        nu1 + nu2 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end
