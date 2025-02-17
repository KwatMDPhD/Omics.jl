module Significance

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

function get_margin_of_error(nu_, fr = 0.95)

    quantile(Normal(), 0.5 + fr * 0.5) * std(nu_) / sqrt(lastindex(nu_))

end

function ge(u1, u2)

    (iszero(u2) ? 1 : u2) / u1

end

function ge(eq, n1_, n2_)

    pv_ = map(nu -> ge(lastindex(n1_), count(eq(nu), n1_)), n2_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

function ge(n1_, p1_, n2_, p2_)

    if isempty(n2_)

        v1_ = Float64[]

        q1_ = Float64[]

    else

        v1_, q1_ = ge(<=, n1_, n2_)

    end

    if isempty(p2_)

        v2_ = Float64[]

        q2_ = Float64[]

    else

        v2_, q2_ = ge(>=, p1_, p2_)

    end

    v1_, q1_, v2_, q2_

end

end
