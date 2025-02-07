module Distance

using Distances: Metric, SemiMetric

using ..Omics

struct Information <: SemiMetric end

function (::Information)(::Real, ::Real)

    NaN

end

function (::Information)(n1_, n2_)

    1.0 - Omics.MutualInformation.get_information_coefficient(n1_, n2_)

end

struct Polar <: Metric end

function (::Polar)(a1, a2)

    a3 = abs(a2 - a1)

    a3 <= pi ? a3 : 2.0 * pi - a3

end

end
