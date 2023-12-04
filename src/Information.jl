module Information

# TODO: Improve bandwidth.
using KernelDensity: default_bandwidth, kde

using Statistics: cor

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

@inline function normalize_mutual_information(mu, e1, e2)

    2mu / (e1 + e2)

end

function get_mutual_informationp(jo)

    p1_ = sum.(eachrow(jo))

    p2_ = sum.(eachcol(jo))

    mu = 0.0

    for (id2, p2) in enumerate(p2_), (id1, p1) in enumerate(p1_)

        pj = jo[id1, id2]

        if !iszero(pj)

            mu += get_kullback_leibler_divergence(pj, p1 * p2)

        end

    end

    mu

end

@inline function _sum_get_entropy(ea)

    get_entropy(sum(ea))

end

function get_mutual_informatione(jo)

    sum(_sum_get_entropy, eachrow(jo)) + sum(_sum_get_entropy, eachcol(jo)) -
    sum(get_entropy(pj) for pj in jo)

end

function get_mutual_information(nu1_::AbstractVector{<:Integer}, nu2_::AbstractVector{<:Integer})

    jo = Nucleus.Collection.count(nu1_, nu2_) / lastindex(nu1_)

    get_mutual_informatione(jo)

end

function get_mutual_information(nu1_, nu2_; ke_ar...)

    de = kde((nu2_, nu1_); ke_ar...).density

    jo = de / sum(de)

    get_mutual_informatione(jo)

end

function get_information_coefficient(mu)

    sqrt(1.0 - exp(-2mu))

end

function get_information_coefficient(
    nu1_::AbstractVector{<:Integer},
    nu2_::AbstractVector{<:Integer},
)

    co = cor(nu1_, nu2_)

    mu = get_mutual_information(nu1_, nu2_)

    sign(co) * get_information_coefficient(mu)

end

function get_information_coefficient(nu1_, nu2_)

    co = cor(nu1_, nu2_)

    fa = 0.75 - 0.75abs(co)

    mu = get_mutual_information(
        nu1_,
        nu2_;
        npoints = (32, 32),
        bandwidth = (default_bandwidth(nu2_) * fa, default_bandwidth(nu1_) * fa),
    )

    sign(co) * get_information_coefficient(mu)

end

end
