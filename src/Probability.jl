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

    Omics.Normalization.normalize_with_sum!(de)

end

function ge(i1_::AbstractVector{<:Integer}, i2_::AbstractVector{<:Integer})

    ge(convert(Matrix{Float64}, Omics.Density.coun(i1_, i2_)))

end

function ge(f1_, f2_; ke_ar...)

    ge(kde((f2_, f1_); ke_ar...).density)

end

function ge(ea::Function, jo)

    map(sum, ea(jo))

end

end
