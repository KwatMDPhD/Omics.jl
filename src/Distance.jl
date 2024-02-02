module Distance

using Distances: CorrDist, Euclidean, SemiMetric, colwise, pairwise

using ..Nucleus

const CO = CorrDist()

const EU = Euclidean()

struct InformationDistance <: SemiMetric end

(::InformationDistance)(n1_, n2_) = 1 - Nucleus.Information.get_information_coefficient(n1_, n2_)

const IN = InformationDistance()

end
