module Matri

using ..Omics

function collapse(fu, ty, ro_, an)

    ur, uc = size(an)

    ro_id_ = Omics.Dic.inde(ro_)

    ro_ = sort!(collect(keys(ro_id_)))

    re = Matrix{ty}(undef, lastindex(ro_), uc)

    for ir in eachindex(ro_)

        id_ = ro_id_[ro_[ir]]

        re[ir, :] =
            isone(lastindex(id_)) ? an[id_[], :] : [fu(an_) for an_ in eachcol(an[id_, :])]

    end

    ro_, re

end

function joi(fi, r1_, c1_, a1, r2_, c2_, a2)

    rj_ = union(r1_, r2_)

    cj_ = union(c1_, c2_)

    aj = fill(fi, lastindex(rj_), lastindex(cj_))

    rj_id = Omics.Dic.index(rj_)

    cj_id = Omics.Dic.index(cj_)

    for ic in eachindex(c1_)

        il = cj_id[c1_[ic]]

        for ir in eachindex(r1_)

            aj[rj_id[r1_[ir]], il] = a1[ir, ic]

        end

    end

    for ic in eachindex(c2_)

        il = cj_id[c2_[ic]]

        for ir in eachindex(r2_)

            aj[rj_id[r2_[ir]], il] = a2[ir, ic]

        end

    end

    rj_, cj_, aj

end

end
