module Significance

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

function _separate(nu_)

    ty = eltype(nu_)

    nn_ = ty[]

    np_ = ty[]

    for nu in nu_

        push!(nu < 0 ? nn_ : np_, nu)

    end

    nn_, np_

end

function get_margin_of_error(sa_, co = 0.95)

    std(sa_) / sqrt(lastindex(sa_)) * quantile(Normal(), 0.5 + co * 0.5)

end

function ge(ur::Integer, us)

    if iszero(ur)

        return 1.0

    end

    if iszero(us)

        us = 1

    end

    us / ur

end

function ge(eq, ra_, nu_)

    ur = lastindex(ra_)

    pv_ = map(nu -> ge(ur, sum(eq(nu), ra_; init = 0)), nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

function ge(ra_, nu_)

    ty = eltype(ra_)

    rn_, rp_ = _separate(ra_)

    nn_, np_ = _separate(nu_)

    if isempty(nn_)

        pn_ = Float64[]

        qn_ = Float64[]

    else

        pn_, qn_ = ge(<=, rn_, nn_)

    end

    if isempty(np_)

        pp_ = Float64[]

        qp_ = Float64[]

    else

        pp_, qp_ = ge(>=, rp_, np_)

    end

    pn_, qn_, pp_, qp_

end

end
