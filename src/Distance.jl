module Distance

using Distances: SemiMetric

using ..Nucleus

struct InformationDistance <: SemiMetric end

function (::InformationDistance)(::Real, ::Real)

    NaN

end

function (::InformationDistance)(n1_::AbstractVector, n2_::AbstractVector)

    1 - Nucleus.Information.get_information_coefficient(n1_, n2_)

end

end
