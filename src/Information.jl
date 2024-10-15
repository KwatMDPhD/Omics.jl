module Information

using Distances: SemiMetric

using KernelDensity: default_bandwidth, kde

using Statistics: cor

using ..Omics

function get_shannon_entropy(pr)

    iszero(pr) ? 0.0 : -pr * log2(pr)

end

function get_kullback_leibler_divergence(n1, n2)

    # TODO: log2
    n1 * log(n1 / n2)

end

function get_thermodynamic_depth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) - get_kullback_leibler_divergence(n2, n1)

end

function get_thermodynamic_breadth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) + get_kullback_leibler_divergence(n2, n1)

end

function get_antisymmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) - get_kullback_leibler_divergence(n2, n4)

end

function get_symmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) + get_kullback_leibler_divergence(n2, n4)

end

function _marginalize(ea, jo)

    map(sum, ea(jo))

end

function get_mutual_information(jo)

    p1_ = _marginalize(eachrow, jo)

    p2_ = _marginalize(eachcol, jo)

    mu = 0.0

    for i2 in eachindex(p2_), i1 in eachindex(p1_)

        pr = jo[i1, i2]

        if !iszero(pr)

            mu += get_kullback_leibler_divergence(pr, p1_[i1] * p2_[i2])

        end

    end

    mu

end

function _marginalize_entropy_sum(ea, jo)

    # TODO: Gain intuition.
    sum(pr_ -> get_shannon_entropy(sum(pr_)), ea(jo))

end

function get_mutual_information(jo, no)

    e1 = _marginalize_entropy_sum(eachrow, jo)

    e2 = _marginalize_entropy_sum(eachcol, jo)

    mu = e1 + e2 - sum(get_shannon_entropy, jo)

    no ? mu = 2.0 * mu / (e1 + e2) : mu

end

function _get_joint(
    ::AbstractFloat,
    n1_::AbstractVector{<:Integer},
    n2_::AbstractVector{<:Integer},
)

    Omics.Normalization.normalize_with_sum!(
        convert(Matrix{Float64}, Omics.Density.coun(n1_, n2_)),
    )

end

function _get_joint(co, n1_, n2_)

    fa = 0.75 - 0.75 * abs(co)

    Omics.Normalization.normalize_with_sum!(
        kde(
            (n2_, n1_);
            npoints = (32, 32),
            bandwidth = (default_bandwidth(n2_) * fa, default_bandwidth(n1_) * fa),
        ).density,
    )

end

function get_information_coefficient(n1_, n2_)

    co = cor(n1_, n2_)

    isnan(co) || isone(abs(co)) ? co :
    sign(co) *
    sqrt(1.0 - exp(-2.0 * get_mutual_information(_get_joint(co, n1_, n2_), false)))

end

struct InformationDistance <: SemiMetric end

function (::InformationDistance)(::Real, ::Real)

    NaN

end

function (::InformationDistance)(n1_, n2_)

    1 - get_information_coefficient(n1_, n2_)

end

end
