module Statistics

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

using ..BioLab

function get_quantile(cu)

    quantile(Normal(), cu)

end

function get_margin_of_error(sa_, co = 0.95)

    get_quantile(0.5 + co / 2) * std(sa_) / sqrt(length(sa_))

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

    pv_ = (nu -> get_p_value(sum(fu(nu), ra_; init = 0), length(ra_))).(nu_)

    pv_, adjust(pv_, BenjaminiHochberg())

end

# TODO: Factor in the outer loop.

function _si(fe_x_id_x_ra, nef_, pof_)

    ne_ = Vector{Float64}()

    po_ = Vector{Float64}()

    for id2 in 1:size(fe_x_id_x_ra, 2), id1 in 1:size(fe_x_id_x_ra, 1)

        ra = fe_x_id_x_ra[id1, id2]

        if BioLab.Number.is_negative(ra)

            ra_ = ne_

            fa_ = nef_

        else

            ra_ = po_

            fa_ = pof_

        end

        if !isnothing(fa_)

            ra *= fa_[id1]

        end

        push!(ra_, ra)

    end

    ne_, po_

end

function get_p_value(nu_, idn_, idp_, fe_x_id_x_ra; nef_ = nothing, pof_ = nothing)

    ne_, po_ = _si(fe_x_id_x_ra, nef_, pof_)

    if isempty(idn_)

        nep_, nea_ = Vector{Float64}(), Vector{Float64}()

    else

        nep_, nea_ = get_p_value(<=, nu_[idn_], ne_)

    end

    if isempty(idp_)

        pop_, poa_ = Vector{Float64}(), Vector{Float64}()

    else

        pop_, poa_ = get_p_value(>=, nu_[idp_], po_)

    end

    nep_, nea_, pop_, poa_

end

end
