module Statistics

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

using ..Nucleus

function get_quantile(cu)

    quantile(Normal(), cu)

end

function get_margin_of_error(sa_, co = 0.95)

    get_quantile(0.5 + 0.5co) * std(sa_) / sqrt(lastindex(sa_))

end

function get_p_value(n_si, n_ra)

    if iszero(n_ra)

        return 1.0

    end

    if iszero(n_si)

        n_si = 1

    end

    n_si / n_ra

end

function get_p_value(fu, nu_, ra_)

    pv_ = (nu -> get_p_value(sum(fu(nu), ra_; init = 0), lastindex(ra_))).(nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

# TODO: Test.

function get_p_value(nu_, nei_, poi_, fe_x_id_x_ra)

    ne_, po_ = Nucleus.Number.separate(fe_x_id_x_ra)

    if isempty(nei_)

        nep_, nea_ = Float64[], Float64[]

    else

        nep_, nea_ = get_p_value(<=, nu_[nei_], ne_)

    end

    if isempty(poi_)

        pop_, poa_ = Float64[], Float64[]

    else

        pop_, poa_ = get_p_value(>=, nu_[poi_], po_)

    end

    nep_, nea_, pop_, poa_

end

end
