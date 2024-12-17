module Matri

using ..Omics

function collapse(fu, ty, ro_, ma)

    ur, uc = size(ma)

    r2_id_ = Omics.Dic.index2(ro_)

    r2_ = sort(collect(keys(r2_id_)))

    m2 = Matrix{ty}(undef, lastindex(r2_), uc)

    for i2 in eachindex(r2_)

        id_ = r2_id_[r2_[i2]]

        m2[i2, :] =
            isone(lastindex(id_)) ? view(ma, id_[], :) :
            [fu(an_) for an_ in eachcol(ma[id_, :])]

    end

    r2_, m2

end

function joi(fi, r1_, c1_, a1, r2_, c2_, a2)

    rj_ = union(r1_, r2_)

    cj_ = union(c1_, c2_)

    aj = fill(fi, lastindex(rj_), lastindex(cj_))

    rj_id = Omics.Dic.index(rj_)

    cj_id = Omics.Dic.index(cj_)

    for ic in eachindex(c1_)

        id = cj_id[c1_[ic]]

        for ir in eachindex(r1_)

            aj[rj_id[r1_[ir]], id] = a1[ir, ic]

        end

    end

    for ic in eachindex(c2_)

        id = cj_id[c2_[ic]]

        for ir in eachindex(r2_)

            aj[rj_id[r2_[ir]], id] = a2[ir, ic]

        end

    end

    rj_, cj_, aj

end

end
