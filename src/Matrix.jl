module Matrix

using OrderedCollections: OrderedDict

function make(an___)

    [an___[id1][id2] for id1 in eachindex(an___), id2 in eachindex(an___[1])]

end

function collapse(fu, ty, ro_, ma)

    ro_id_ = OrderedDict{String, Vector{Int}}()

    for (id, ro) in enumerate(ro_)

        if !haskey(ro_id_, ro)

            ro_id_[ro] = Int[]

        end

        push!(ro_id_[ro], id)

    end

    n_ro, n_co = size(ma)

    n_roc = length(ro_id_)

    if n_ro == n_roc

        error("There are not any rows to collapse.")

    end

    @info "Collapsing using `$fu` and making ($n_ro -->) $n_roc x $n_co"

    roc_ = Vector{String}(undef, n_roc)

    mac = Base.Matrix{ty}(undef, n_roc, n_co)

    for (idc, (ro, id_)) in enumerate(ro_id_)

        roc_[idc] = ro

        mac[idc, :] =
            isone(lastindex(id_)) ? view(ma, id_[1], :) : [fu(co) for co in eachcol(ma[id_, :])]

    end

    roc_, mac

end

end
