module Information

function get_entropy(nu_)

    return 0.0

end

function get_kullback_leibler_divergence(nu1_, nu2_)

    return [nu1 * log(nu1 / nu2) for (nu1, nu2) in zip(nu1_, nu2_)]

end

function get_thermodynamic_breadth(nu1_, nu2_)

    return [
        nu1 + nu2 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end

function get_thermodynamic_depth(nu1_, nu2_)

    return [
        nu1 - nu2 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end

function get_symmetric_kullback_leibler_divergence(nu1_, nu2_, nu_; we1 = 0.5, we2 = 0.5)

    return [
        nu1 * we1 + nu2 * we2 for (nu1, nu2) in
        zip(get_kullback_leibler_divergence(nu1_, nu_), get_kullback_leibler_divergence(nu2_, nu_))
    ]

end

function get_antisymmetric_kullback_leibler_divergence(nu1_, nu2_, nu_; we1 = 0.5, we2 = 0.5)

    return [
        nu1 * we1 - nu2 * we2 for (nu1, nu2) in
        zip(get_kullback_leibler_divergence(nu1_, nu_), get_kullback_leibler_divergence(nu2_, nu_))
    ]

end

function get_mutual_information(nu1_, nu2_)

    return 0.0

end

function get_information_coefficient(nu1_, nu2_)

    return get_mutual_information(nu1_, nu2_)

end

end
