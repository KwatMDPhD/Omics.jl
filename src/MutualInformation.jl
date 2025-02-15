module MutualInformation

using KernelDensity: default_bandwidth, kde

using Statistics: cor

using StatsBase: counts

using ..Omics

function _get_density(
    n1_::AbstractVector{<:Integer},
    n2_::AbstractVector{<:Integer},
    ::AbstractFloat,
)

    convert(Matrix{Float64}, counts(n1_, n2_))

end

function _get_density(n1_, n2_, co; um = 32, fr = 0.75)

    fr *= 1.0 - abs(co)

    kde(
        (n1_, n2_);
        npoints = (um, um),
        bandwidth = (default_bandwidth(n1_) * fr, default_bandwidth(n2_) * fr),
    ).density

end

function get_mutual_information(pr)

    p1_ = map(sum, eachrow(pr))

    p2_ = map(sum, eachcol(pr))

    mu = 0.0

    for i2 in eachindex(p2_), i1 in eachindex(p1_)

        on = pr[i1, i2]

        if !iszero(on)

            mu += Omics.Information.get_kullback_leibler_divergence(on, p1_[i1] * p2_[i2])

        end

    end

    mu

end

function get_mutual_information(pr, no)

    e1 = Omics.Entropy.ge(eachrow, pr)

    e2 = Omics.Entropy.ge(eachcol, pr)

    mu = e1 + e2 - sum(Omics.Entropy.ge, pr)

    no ? 2.0 * mu / (e1 + e2) : mu

end

function get_information_coefficient(n1_, n2_)

    co = cor(n1_, n2_)

    if isnan(co) || isone(abs(co))

        return co

    end

    mu = get_mutual_information(
        Omics.Normalization.normalize_with_sum!(_get_density(n1_, n2_, co)),
        false,
    )

    # TODO: Confirm e.
    sign(co) * sqrt(1.0 - exp(-2.0 * mu))

end

end
