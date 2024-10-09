module Significance

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

function get_margin_of_error(sa_, co = 0.95)

    std(sa_) / sqrt(lastindex(sa_)) * quantile(Normal(), 0.5 + 0.5 * co)

end

function get_p_value(us, ur)

    if iszero(ur)

        return 1.0

    end

    if iszero(us)

        us = 1

    end

    us / ur

end

function get_p_value(eq, nu_, ra_)

    pv_ = map(nu -> get_p_value(sum(eq(nu), ra_; init = 0), lastindex(ra_)), nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

function get_p_value(nu_, ie_, ip_, ra_)

    rn_ = eltype(ra_)[]

    rp_ = eltype(ra_)[]

    for ra in ra_

        push!(ra < 0 ? rn_ : rp_, ra)

    end

    if isempty(ie_)

        pn_ = Float64[]

        an_ = Float64[]

    else

        pn_, an_ = get_p_value(<=, nu_[ie_], rn_)

    end

    if isempty(ip_)

        pp_ = Float64[]

        ap_ = Float64[]

    else

        pp_, ap_ = get_p_value(>=, nu_[ip_], rp_)

    end

    pn_, an_, pp_, ap_

end

end
