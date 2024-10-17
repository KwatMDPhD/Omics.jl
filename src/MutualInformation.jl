module MutualInformation

using KernelDensity: default_bandwidth

using Statistics: cor

using ..Omics

function get_mutual_information(jo)

    p1_ = Omics.Probability.ge(eachrow, jo)

    p2_ = Omics.Probability.ge(eachcol, jo)

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

    mu = e1 + e2 - Omics.Entropy.ge(jo)

    no ? 2.0 * mu / (e1 + e2) : mu

end

function get_information_coefficient(n1_, n2_)

    co = cor(n1_, n2_)

    if isnan(co) || isone(abs(co))

        return co

    end

    fa = 0.75 - 0.75 * abs(co)

    # TODO: Pick one
    mu = get_mutual_information(
        Omics.Normalization.normalize_with_01!(
            Omics.Probability.ge(
                n1_,
                n2_;
                npoints = (32, 32),
                bandwidth = (default_bandwidth(n1_) * fa, default_bandwidth(n2_) * fa),
            ),
        ),
    )

    sign(co) * sqrt(1.0 - exp(-2.0 * mu))

end

end
