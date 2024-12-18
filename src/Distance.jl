module Distance

using Distances: SemiMetric

using ..Omics

struct Information <: SemiMetric end

function (::Information)(::Real, ::Real)

    NaN

end

function (::Information)(n1_, n2_)

    1 - Omics.MutualInformation.get_information_coefficient(n1_, n2_)

end

end
