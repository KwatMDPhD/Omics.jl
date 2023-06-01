module Information

function get_entropy(nu_)

    0.0

end

function get_kullback_leibler_divergence(nu1, nu2)

    nu1 * log(nu1 / nu2)

end

function get_thermodynamic_breadth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) + get_kullback_leibler_divergence(nu2, nu1)

end

function get_thermodynamic_depth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) - get_kullback_leibler_divergence(nu2, nu1)

end

function get_symmetric_kullback_leibler_divergence(nu1, nu2, nu; we1 = 0.5, we2 = 0.5)

    get_kullback_leibler_divergence(nu1, nu) * we1 + get_kullback_leibler_divergence(nu2, nu) * we2

end

function get_antisymmetric_kullback_leibler_divergence(nu1, nu2, nu; we1 = 0.5, we2 = 0.5)

    get_kullback_leibler_divergence(nu1, nu) * we1 - get_kullback_leibler_divergence(nu2, nu) * we2

end

function get_mutual_information(nu1_, nu2_)

    0.0

end

function get_information_coefficient(nu1_, nu2_)

    get_mutual_information(nu1_, nu2_)

end

end
