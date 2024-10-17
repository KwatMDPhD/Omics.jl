module Distance

using Distances: SemiMetric

using ..Omics

struct InformationDistance <: SemiMetric end

function (::InformationDistance)(::Real, ::Real)

    NaN

end

function (::InformationDistance)(n1_, n2_)

    1 - Omics.MutualInformation.get_information_coefficient(n1_, n2_)

end

end
