module Distance

using Distances: CorrDist, Euclidean, SemiMetric, colwise, pairwise

using ..Nucleus

const CO = CorrDist()

const EU = Euclidean()

struct InformationDistance <: SemiMetric end

function (::InformationDistance)(::Real, ::Real)

    NaN

end

function (::InformationDistance)(n1_::AbstractVector, n2_::AbstractVector)

    1 - Nucleus.Information.get_information_coefficient(n1_, n2_)

end

const IN = InformationDistance()

end
