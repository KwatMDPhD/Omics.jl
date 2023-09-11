module Statistics

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

using ..BioLab

function get_z_score(cu)

    quantile(Normal(), cu)

end

function get_margin_of_error(nu_, er = 0.05)

    get_z_score(1 - er / 2) * std(nu_) / sqrt(length(nu_))

end

function get_p_value(n_si::Int, n_ra)

    if iszero(n_si)

        n_si = 1

    end

    n_si / n_ra

end

function get_p_value(fu, nu_, ra_)

    n = length(nu_)

    is_ = falses(n)

    pv_ = fill(NaN, n)

    n_ra = length(ra_)

    for (id, nu) in enumerate(nu_)

        if !isnan(nu)

            is_[id] = true

            pv_[id] = get_p_value(sum(fu(nu), ra_), n_ra)

        end

    end

    ad_ = fill(NaN, n)

    ad_[is_] .= adjust(pv_[is_], n, BenjaminiHochberg())

    pv_, ad_

end

function get_p_value(nu_::AbstractVector, ra_)

    pvl_, adl_ = get_p_value(<=, nu_, ra_)

    pvg_, adg_ = get_p_value(>=, nu_, ra_)

    n = length(nu_)

    pv_ = Vector{Float64}(undef, n)

    ad_ = Vector{Float64}(undef, n)

    for (id, (pvl, adl, pvg, adg)) in enumerate(zip(pvl_, adl_, pvg_, adg_))

        # TODO: Check if both must come from the same side.

        if pvl <= pvg

            pv = pvl

        else

            pv = pvg

        end

        pv_[id] = pv

        if adl <= adg

            ad = adl

        else

            ad = adg

        end

        ad_[id] = ad

    end

    pv_, ad_

end

end
