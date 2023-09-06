module Matrix

using OrderedCollections: OrderedDict

function make(an___)

    le_ = unique(length.(an___))

    if isone(length(le_))

        [an___[id1][id2] for id1 in eachindex(an___), id2 in 1:le_[1]]

    else

        error("Lengths differ.")

    end

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

    @info "Collapsing using $fu and making ($n_ro -->) $n_ro2 x $n_co"

    ro2_ = Vector{String}(undef, n_ro2)

    ma2 = Base.Matrix{ty}(undef, n_ro2, n_co)

    for (id2, (ro, id_)) in enumerate(ro_id_)

        ro2_[id2] = ro

        if isone(length(id_))

            an_ = view(ma, id_[1], :)

        else

            # `view` allocates one more and is slower.
            # `fu.(` allocates six more and is slower.
            an_ = [fu(co) for co in eachcol(ma[id_, :])]

        end

        # TODO: Benchmark in-place assignment.
        ma2[id2, :] = an_

    end

    ro2_, ma2

end

end
