module Matrix

using ..Nucleus

function collapse(fu, ty, ro_, ma)

    n_ro, n_co = size(ma)

    ro_id_ = Nucleus.Collection.map_index(ro_)

    n_ro2 = length(ro_id_)

    if n_ro == n_ro2

        error("There are not any rows to collapse.")

    end

    @info "Collapsing using `$fu` and making ($n_ro -->) $n_ro2 x $n_co"

    ro2_ = Vector{String}(undef, n_ro2)

    ma2 = Base.Matrix{ty}(undef, n_ro2, n_co)

    for (id, (ro, id_)) in enumerate(ro_id_)

        ro2_[id] = ro

        ma2[id, :] =
            isone(lastindex(id_)) ? view(ma, id_[1], :) : [fu(co) for co in eachcol(ma[id_, :])]

    end

    ro2_, ma2

end

end
