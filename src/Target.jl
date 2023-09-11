module Target

using ..BioLab

function tabulate(ro_)

    rou_ = BioLab.Collection.unique_sort(ro_)

    ro_x_id_x_is = falses(length(rou_), length(ro_))

    ro_id = BioLab.Collection.map_index(rou_)

    for (id, ro) in enumerate(ro_)

        ro_x_id_x_is[ro_id[ro], id] = true

    end

    rou_, ro_x_id_x_is

end

function tabulate(ro___, co___, fi, an_)

    BioLab.Error.error_length_difference((ro___..., co___..., an_))

    ro_ = zip(ro___...)

    co_ = zip(co___...)

    rou_ = BioLab.Collection.unique_sort(ro_)

    cou_ = BioLab.Collection.unique_sort(co_)

    ro_x_co_x_an = fill(fi, length(rou_), length(cou_))

    ro_id = BioLab.Collection.map_index(rou_)

    co_id = BioLab.Collection.map_index(cou_)

    for (ro, co, an) in zip(ro_, co_, an_)

        ro_x_co_x_an[ro_id[ro], co_id[co]] = an

    end

    join.(rou_, '_'), join.(cou_, '_'), ro_x_co_x_an

end

function tabulate(ro_re_, co_)

    n_ro = length(ro_re_)

    ro_ = Vector{String}(undef, n_ro)

    ro_x_co_x_nu = fill(NaN, n_ro, length(co_))

    for (idr, (ro, re_)) in enumerate(ro_re_)

        ro_[idr] = ro

        for (nu, re) in zip((0, 1), re_)

            re2 = Regex(re)

            for (idc, co) in enumerate(co_)

                if contains(co, re2)

                    ro_x_co_x_nu[idr, idc] = nu

                end

            end

        end

    end

    ro_, ro_x_co_x_nu

end

end
