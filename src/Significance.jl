module Significance

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

function get_margin_of_error(sa_, co = 0.95)

    std(sa_) / sqrt(lastindex(sa_)) * quantile(Normal(), 0.5 + co * 0.5)

end

function get(ur, us)

    if iszero(ur)

        return 1.0

    end

    if iszero(us)

        us = 1

    end

    us / ur

end

function get(eq, ra_, nu_)

    ur = lastindex(ra_)

    pv_ = map(nu -> get(ur, sum(eq(nu), ra_; init = 0)), nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

function get(ra_, nu_, il_, ig_)

    ty = eltype(ra_)

    rl_ = ty[]

    rg_ = ty[]

    for ra in ra_

        push!(ra < 0 ? rl_ : rg_, ra)

    end

    if isempty(il_)

        pl_ = Float64[]

        ql_ = Float64[]

    else

        pl_, ql_ = get(<=, rl_, nu_[il_])

    end

    if isempty(ig_)

        pg_ = Float64[]

        qg_ = Float64[]

    else

        pg_, qg_ = get(>=, rg_, nu_[ig_])

    end

    pl_, ql_, pg_, qg_

end

end
