module MutualInformation

using KernelDensity: default_bandwidth, kde

using Statistics: cor

using ..Omics

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

            mu += Omics.Information.get_kullback_leibler_divergence(pr, p1_[i1] * p2_[i2])

        end

    end

    mu

end

function _marginalize_entropy_sum(ea, jo)

    sum(pr_ -> Omics.Information.get_shannon_entropy(sum(pr_)), ea(jo))

end

function _entropy_sum(jo)

    en = 0.0

    for pr in jo

        if !iszero(pr)

            en += Omics.Information.get_shannon_entropy(pr)

        end

    end

    en

end

function get_mutual_information(jo, no)

    e1 = _marginalize_entropy_sum(eachrow, jo)

    e2 = _marginalize_entropy_sum(eachcol, jo)

    mu = e1 + e2 - _entropy_sum(jo)

    no ? 2.0 * mu / (e1 + e2) : mu

end

function _get_joint(
    ::AbstractFloat,
    i1_::AbstractVector{<:Integer},
    i2_::AbstractVector{<:Integer},
)

    Omics.Normalization.normalize_with_sum!(
        convert(Matrix{Float64}, Omics.Density.coun(i1_, i2_)),
    )

end

function _get_joint(co, f1_, f2_)

    fa = 0.75 - 0.75 * abs(co)

    Omics.Normalization.normalize_with_sum!(
        kde(
            (f2_, f1_);
            npoints = (32, 32),
            bandwidth = (default_bandwidth(f2_) * fa, default_bandwidth(f1_) * fa),
        ).density,
    )

end

function get_information_coefficient(n1_, n2_)

    co = cor(n1_, n2_)

    isnan(co) || isone(abs(co)) ? co :
    sign(co) * sqrt(1.0 - exp(-2.0 * get_mutual_information(_get_joint(co, n1_, n2_))))

end

end
