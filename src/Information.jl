module Information

using KernelDensity: kde

using ..Nucleus

function get_entropy(nu_)

    su = 0.0

    for nu in nu_

        if !iszero(nu)

            su -= nu * log(nu)

        end

    end

    su

end

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

function get_mutual_information(jo; no = false)

    p1_ = sum.(eachrow(jo))

    p2_ = sum.(eachcol(jo))

    mu = 0.0

    for (id2, p2) in enumerate(p2_), (id1, p1) in enumerate(p1_)

        pp = jo[id1, id2]

        if !iszero(pp)

            mu += get_kullback_leibler_divergence(pp, p1 * p2)

        end

    end

    if no

        mu = 2mu / (get_entropy(p1_) + get_entropy(p2_))

    end

    mu

end

function get_mutual_information(
    nu1_::AbstractVector{<:Integer},
    nu2_::AbstractVector{<:Integer};
    ke_ar...,
)

    get_mutual_information(Nucleus.Collection.count(nu1_, nu2_) / lastindex(nu1_); ke_ar...)

end

function get_mutual_information(nu1_, nu2_; ke_ar...)

    get_mutual_information(jo; ke_ar...)

end

function get_information_coefficient(nu1_, nu2_)

end

end
