module NumberMatrix

using OrderedCollections: OrderedDict

function collapse(fu, ty, ro_, ma)

    ro_id_ = OrderedDict{String, Vector{Int}}()

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Vector{Int}()), id)

    end

    n_ro, n_co = size(ma)

    n_ro2 = length(ro_id_)

    if n_ro == n_ro2

        @warn "There are no rows to collapse."

        return

    end

    @info "Collapsing using $fu and making ($n_ro --> $n_ro2) x $n_co"

    ro2_ = Vector{String}(undef, n_ro2)

    ma2 = Matrix{ty}(undef, (n_ro2, n_co))

    for (id2, (ro, id_)) in enumerate(ro_id_)

        ro2_[id2] = ro

        if length(id_) == 1

            an_ = ma[id_[1], :]

        else

            an_ = map(fu, eachcol(view(ma, id_, :)))

        end

        ma2[id2, :] = an_

    end

    ro2_, ma2

end

end