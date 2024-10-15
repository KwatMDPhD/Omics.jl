module Probability

using KernelDensity: default_bandwidth, kde

using ..Omics

function get_odd(pr)

    pr / (1 - pr)

end

function ge(od::Real)

    od / (1 + od)

end

function ge(de)

    Omics.Normalization.normalize_with_sum!(convert(Matrix{Float64}, de))

end

function ge(::AbstractFloat, i1_::AbstractVector{<:Integer}, i2_::AbstractVector{<:Integer})

    ge(Omics.Density.coun(i1_, i2_))

end

function ge(co, f1_, f2_)

    fa = 0.75 - 0.75 * abs(co)

    ge(
        kde(
            (f2_, f1_);
            npoints = (32, 32),
            bandwidth = (default_bandwidth(f2_) * fa, default_bandwidth(f1_) * fa),
        ).density,
    )

end

function ge(ea, jo)

    map(sum, ea(jo))

end

end
