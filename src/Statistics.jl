module Statistics

using Distributions: Normal, quantile

using MultipleTesting: BenjaminiHochberg, adjust

using StatsBase: std

using ..BioLab

function get_quantile(cu)

    quantile(Normal(), cu)

end

function get_margin_of_error(nu_, co = 0.95)

    get_quantile(0.5 + co / 2) * std(nu_) / sqrt(length(nu_))

end

function get_p_value(n_si::Int, n_ra)

    if iszero(n_ra)

        return NaN

    end

    if iszero(n_si)

        n_si = 1

    end

    n_si / n_ra

end

function get_p_value(fu, nu_, ra_)

    n = length(nu_)

    is_ = BitVector(undef, n)

    pv_ = Vector{Float64}(undef, n)

    ad_ = fill(NaN, n)

    ra_ = filter(.!isnan, ra_)

    n_ra = length(ra_)

    if iszero(n_ra)

        pv_ .= NaN

        return pv_, ad_

    end

    for (id, nu) in enumerate(nu_)

        if isnan(nu)

            is_[id] = false

            pv_[id] = NaN

        else

            is_[id] = true

            pv_[id] = get_p_value(sum(fu(nu), ra_; init = 0), n_ra)

        end

    end

    if any(is_)

        ad_[is_] = adjust(pv_[is_], n, BenjaminiHochberg())

    end

    pv_, ad_

end

function _get_negative_positive(sc_)

    sc_ .< 0, 0 .<= sc_

end

function get_p_value(sc_, nei_, poi_, fe_x_id_x_ra; nef_ = nothing, pof_ = nothing)

    ne_ = Vector{Float64}()

    po_ = Vector{Float64}()

    for id2 in 1:size(fe_x_id_x_ra, 2), id1 in 1:size(fe_x_id_x_ra, 1)

        ra = fe_x_id_x_ra[id1, id2]

        if isnan(ra)

            continue

        end

        if ra < 0

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

    nep_, nea_ = get_p_value(<=, view(sc_, nei_), ne_)

    pop_, poa_ = get_p_value(>=, view(sc_, poi_), po_)

    nep_, nea_, pop_, poa_

end

end
