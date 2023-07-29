module Significance

using StatsBase: std

using MultipleTesting: BenjaminiHochberg, adjust

using BioLab

function get_margin_of_error(nu_, er = 0.05)

    BioLab.Statistics.get_z_score(1 - er / 2) * std(nu_) / sqrt(length(nu_))

end

# TODO: Use multiple dispatch.

@inline function _get_p_value(n, ra_)

    if iszero(n)

        n = 1

    end

    n / length(ra_)

end

function get_p_value_for_less(nu, ra_)

    if isnan(nu)

        return NaN

    end

    _get_p_value(sum(<=(nu), ra_), ra_)

end

function get_p_value_for_more(nu, ra_)

    if isnan(nu)

        return NaN

    end

    _get_p_value(sum(>=(nu), ra_), ra_)

end

function get_p_value_adjust(fu, nu_, ra_)

    pv_ = (nu -> fu(nu, ra_)).(nu_)

    n = length(pv_)

    ad_ = fill(NaN, n)

    no_ = .!isnan.(pv_)

    ad_[no_] .= adjust(pv_[no_], n, BenjaminiHochberg())

    pv_, ad_

end

function get_p_value_adjust(nu_, ra_)

    pvl_, adl_ = get_p_value_adjust(get_p_value_for_less, nu_, ra_)

    pvm_, adm_ = get_p_value_adjust(get_p_value_for_more, nu_, ra_)

    ifelse.(pvl_ .< pvm_, pvl_, pvm_), ifelse.(adl_ .< adm_, adl_, adm_)

end

end
