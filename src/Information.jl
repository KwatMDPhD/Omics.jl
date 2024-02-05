module Information

using Statistics: cor

using ..Nucleus

@inline function get_kullback_leibler_divergence(n1, n2)

    n1 * log(n1 / n2)

end

@inline function get_antisymmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) - get_kullback_leibler_divergence(n2, n4)

end

@inline function get_symmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) + get_kullback_leibler_divergence(n2, n4)

end

@inline function get_thermodynamic_depth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) - get_kullback_leibler_divergence(n2, n1)

end

@inline function get_thermodynamic_breadth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) + get_kullback_leibler_divergence(n2, n1)

end

@inline function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log(nu)

end

function get_mutual_information(jo)

    p1_ = sum.(eachrow(jo))

    p2_ = sum.(eachcol(jo))

    mu = 0.0

    for (i2, p2) in enumerate(p2_), (i1, p1) in enumerate(p1_)

        pj = jo[i1, i2]

        if !iszero(pj)

            mu += get_kullback_leibler_divergence(pj, p1 * p2)

        end

    end

    mu

end

@inline function _sum_get_entropy(nu_)

    get_entropy(sum(nu_))

end

function get_mutual_information(jo, no)

    e1 = sum(_sum_get_entropy, eachrow(jo))

    e2 = sum(_sum_get_entropy, eachcol(jo))

    mu = e1 + e2 - sum(get_entropy(pj) for pj in jo)

    if no

        mu = 2.0 * mu / (e1 + e2)

    end

    mu

end

function _convert(mu)

    sqrt(1.0 - exp(-2.0 * mu))

end

function get_information_coefficient(
    i1_::AbstractVector{<:Integer},
    i2_::AbstractVector{<:Integer},
)

    sign(cor(i1_, i2_)) *
    _convert(get_mutual_information(Nucleus.Probability.get_joint(i1_, i2_), false))

end

function get_information_coefficient(n1_, n2_)

    # TODO: Decide when to use the `Integer` dispatch.
    # TODO: Try changing the grid sizes for smaller vectors.
    if lastindex(unique(n1_)) == lastindex(unique(n2_)) == 2

        return sign(n1_[1] - n1_[2]) == sign(n2_[1] - n2_[2]) ? 1.0 : -1.0

    end

    co = cor(n1_, n2_)

    fa = 0.75 - 0.75 * abs(co)

    sign(co) * _convert(
        get_mutual_information(
            Nucleus.Probability.get_joint(
                n1_,
                n2_;
                npoints = (32, 32),
                bandwidth = (
                    Nucleus.Density.get_bandwidth(n2_) * fa,
                    Nucleus.Density.get_bandwidth(n1_) * fa,
                ),
            ),
            false,
        ),
    )

end

end
