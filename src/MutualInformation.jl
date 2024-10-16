module MutualInformation

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
    fa = 0.75 - 0.75 * abs(co)
    npoints = (32, 32)
    bandwidth = (default_bandwidth(f2_) * fa, default_bandwidth(f1_) * fa)

    isnan(co) || isone(abs(co)) ? co :
    sign(co) *
    sqrt(1.0 - exp(-2.0 * get_mutual_information(Omics.Probability.ge(co, n1_, n2_))))

end

end
