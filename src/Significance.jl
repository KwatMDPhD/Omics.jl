module Significance

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

function get_margin_of_error(sa_, co = 0.95)

    std(sa_) / sqrt(lastindex(sa_)) * quantile(Normal(), 0.5 + co * 0.5)

end

function get_p_value(ur, us)

    if iszero(ur)

        return 1.0

    end

    if iszero(us)

        us = 1

    end

    us / ur

end

function get_p_value(eq, ra_, nu_)

    pv_ = map(nu -> get_p_value(lastindex(ra_), sum(eq(nu), ra_; init = 0)), nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

function get_p_value(ra_, nu_, ie_, ip_)

    ty = eltype(ra_)

    rn_ = ty[]

    rp_ = ty[]

    for ra in ra_

        push!(ra < 0 ? rn_ : rp_, ra)

    end

    if isempty(ie_)

        pn_ = Float64[]

        an_ = Float64[]

    else

        pn_, an_ = get_p_value(<=, rn_, nu_[ie_])

    end

    if isempty(ip_)

        pp_ = Float64[]

        ap_ = Float64[]

    else

        pp_, ap_ = get_p_value(>=, rp_, nu_[ip_])

    end

    pn_, an_, pp_, ap_

end

end
