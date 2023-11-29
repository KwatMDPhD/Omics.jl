module Information

using KernelDensity: kde

using ..Nucleus

@inline function get_kullback_leibler_divergence(nu1, nu2)

    nu1 * log(nu1 / nu2)

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

@inline function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log(nu)

end

@inline function normalize_mutual_information(mu, h1, h2)

    2mu / (h1 + h2)

end

function get_mutual_informationp(jo; no = false)

    p1_ = sum.(eachrow(jo))

    p2_ = sum.(eachcol(jo))

    mu = 0.0

    for (id2, p2) in enumerate(p2_), (id1, p1) in enumerate(p1_)

        pj = jo[id1, id2]

        if !iszero(pj)

            mu += get_kullback_leibler_divergence(pj, p1 * p2)

        end

    end

    if no

        normalize_mutual_information(mu, sum(get_entropy, p1_), sum(get_entropy, p2_))

    else

        mu

    end

end

@inline function _sum_get_entropy(ea)

    get_entropy(sum(ea))

end

function get_mutual_informatione(jo; no = false)

    h1 = sum(_sum_get_entropy, eachrow(jo))

    h2 = sum(_sum_get_entropy, eachcol(jo))

    mu = h1 + h2 - sum(get_entropy(pj) for pj in jo)

    if no

        normalize_mutual_information(mu, h1, h2)

    else

        mu

    end

end

function get_mutual_information(
    nu1_::AbstractVector{<:Integer},
    nu2_::AbstractVector{<:Integer};
    ke_ar...,
)

    get_mutual_informatione(Nucleus.Collection.count(nu1_, nu2_) / lastindex(nu1_); ke_ar...)

end

function get_mutual_information(nu1_, nu2_; ke_ar...)

    get_mutual_informatione(jo; ke_ar...)

end

function get_information_coefficient(nu1_, nu2_; ke_ar...)

end

end
