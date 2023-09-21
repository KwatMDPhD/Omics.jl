module Matrix

using OrderedCollections: OrderedDict

using ..BioLab

function make(an___)

    BioLab.Error.error_length_difference(an___)

    [an___[id1][id2] for id1 in eachindex(an___), id2 in eachindex(an___[1])]

end

function collapse(fu, ty, ro_, ma)

    ro_id_ = OrderedDict{String, Vector{Int}}()

    for (id, ro) in enumerate(ro_)

        if !haskey(ro_id_, ro)

            ro_id_[ro] = Vector{Int}()

        end

        push!(ro_id_[ro], id)

    end

    n_ro, n_co = size(ma)

    n_ro2 = length(ro_id_)

    if n_ro == n_ro2

        @warn "There are not any rows to collapse."

        return

    end

    @info "Collapsing using `$fu` and making ($n_ro -->) $n_ro2 x $n_co"

    ro2_ = Vector{String}(undef, n_ro2)

    ma2 = Base.Matrix{ty}(undef, n_ro2, n_co)

    for (id2, (ro, id_)) in enumerate(ro_id_)

        ro2_[id2] = ro

        if isone(length(id_))

            an_ = ma[id_[1], :]

        else

            an_ = [fu(co) for co in eachcol(ma[id_, :])]

        end

        ma2[id2, :] = an_

    end

    ro2_, ma2

end

end
