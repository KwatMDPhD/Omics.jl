module MutualInformation

using KernelDensity: default_bandwidth, kde

using Statistics: cor

using StatsBase: counts

using ..Omics

function _get_density(
    i1_::AbstractVector{<:Integer},
    i2_::AbstractVector{<:Integer},
    ::AbstractFloat,
)

    convert(Matrix{Float64}, counts(i1_, i2_))

end

function _get_density(f1_, f2_, co; ug = 32, ma = 0.75)

    ba = ma - ma * abs(co)

    kde(
        (f1_, f2_);
        npoints = (ug, ug),
        bandwidth = (default_bandwidth(f1_) * ba, default_bandwidth(f2_) * ba),
    ).density

end

function get_mutual_information(jo)

    p1_ = map(sum, eachrow(jo))

    p2_ = map(sum, eachcol(jo))

    mu = 0.0

    for i2 in eachindex(p2_), i1 in eachindex(p1_)

        pr = jo[i1, i2]

        if !iszero(pr)

            mu += Omics.Information.get_kullback_leibler_divergence(pr, p1_[i1] * p2_[i2])

        end

    end

    mu

end

function get_mutual_information(jo, no)

    e1 = Omics.Entropy.ge(eachrow, jo)

    e2 = Omics.Entropy.ge(eachcol, jo)

    mu = e1 + e2 - sum(Omics.Entropy.ge, jo)

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

    # TODO: Confirm e
    sign(co) * sqrt(1.0 - exp(-2.0 * mu))

end

end
