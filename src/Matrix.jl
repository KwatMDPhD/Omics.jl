module Matrix

using ..Nucleus

function collapse(fu, ty, ro_, ma)

    nr, nc = size(ma)

    ro_id_ = Nucleus.Collection.map_index2(ro_)

    n2 = length(ro_id_)

    if nr == n2

        error("There are not any rows to collapse.")

    end

    @info "Collapsing using `$fu` and making ($nr -->) $n2 x $nc"

    r2_ = Vector{String}(undef, n2)

    m2 = Base.Matrix{ty}(undef, n2, nc)

    for (i2, (ro, id_)) in enumerate(ro_id_)

        r2_[i2] = ro

        m2[i2, :] =
            isone(lastindex(id_)) ? view(ma, id_[1], :) : [fu(co) for co in eachcol(ma[id_, :])]

    end

    r2_, m2

end

function join(fi, r1_, c1_, a1, r2_, c2_, a2)

    rj_ = union(r1_, r2_)

    cj_ = vcat(c1_, c2_)

    aj = fill(fi, lastindex(rj_), lastindex(cj_))

    ro_id = Nucleus.Collection._map_index(rj_)

    co_id = Nucleus.Collection._map_index(cj_)

    for (ro_, co_, an) in ((r1_, c1_, a1), (r2_, c2_, a2))

        for (ic, co) in enumerate(co_), (ir, ro) in enumerate(ro_)

            aj[ro_id[ro], co_id[co]] = an[ir, ic]

        end

    end

    rj_, cj_, aj

end

end
