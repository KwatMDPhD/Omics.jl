module Information

using KernelDensity: kde

# TODO
function get_entropy(nu_)

end

@inline function get_kullback_leibler_divergence(nu1, nu2)

    # TODO
    nu1 * log((nu1 + 1e-16) / (nu2 + 1e-16))

end

@inline function get_thermodynamic_depth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) - get_kullback_leibler_divergence(nu2, nu1)

end

@inline function get_thermodynamic_breadth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) + get_kullback_leibler_divergence(nu2, nu1)

end

@inline function get_antisymmetric_kullback_leibler_divergence(nu1, nu2, nu3, nu4 = nu3)

    get_kullback_leibler_divergence(nu1, nu3) - get_kullback_leibler_divergence(nu2, nu4)

end

@inline function get_symmetric_kullback_leibler_divergence(nu1, nu2, nu3, nu4 = nu3)

    get_kullback_leibler_divergence(nu1, nu3) + get_kullback_leibler_divergence(nu2, nu4)

end

# TODO
function get_mutual_information(nu1_, nu2_)

end

# TODO
function get_information_coefficient(nu1_, nu2_)

end

end
