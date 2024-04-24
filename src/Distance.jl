module Distance

using Distances: Metric, SemiMetric

using ..Nucleus

struct InformationDistance <: SemiMetric end

function (::InformationDistance)(::Real, ::Real)

    NaN

end

function (::InformationDistance)(n1_::AbstractVector, n2_::AbstractVector)

    1 - Nucleus.Information.get_information_coefficient(n1_, n2_)

end

struct AngularDistance <: Metric end

function (::AngularDistance)(a1::Real, a2::Real)

    di = mod2pi(a2) - mod2pi(a1)

    if abs(di) < sqrt(eps())

        di = 0.0

    end

    di

end

struct AngularDistance2 <: Metric end

function (::AngularDistance2)(a1::Real, a2::Real)

    di = abs(AngularDistance()(a1, a2))

    if pi < di

        di = 2 * pi - di

    end

    di

end

end
