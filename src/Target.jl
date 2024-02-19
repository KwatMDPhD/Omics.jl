module Target

using ..Nucleus

function tabulate(ro_)

    rou_ = sort!(unique(ro_))

    ro_x_id_x_is = falses(lastindex(rou_), lastindex(ro_))

    ro_id = Nucleus.Collection._map_index(rou_)

    for (id, ro) in enumerate(ro_)

        ro_x_id_x_is[ro_id[ro], id] = true

    end

    rou_, ro_x_id_x_is

end

function _fuse(an___)

    if isone(lastindex(an___))

        an___[1]

    else

        zip(an___...)

    end

end

function tabulate(ro___, co___, fl_)

    ro_ = _fuse(ro___)

    co_ = _fuse(co___)

    rou_ = sort!(unique(ro_))

    cou_ = sort!(unique(co_))

    ro_x_co_x_fl = fill(NaN, lastindex(rou_), lastindex(cou_))

    ro_id = Nucleus.Collection._map_index(rou_)

    co_id = Nucleus.Collection._map_index(cou_)

    for (ro, co, fl) in zip(ro_, co_, fl_)

        ro_x_co_x_fl[ro_id[ro], co_id[co]] = fl

    end

    rou_, cou_, ro_x_co_x_fl

end

function tabulate(ro_re_, co_)

    n_ro = length(ro_re_)

    ro_ = Vector{String}(undef, n_ro)

    ro_x_co_x_fl = fill(NaN, n_ro, lastindex(co_))

    fl_ = (0.0, 1.0)

    for (idr, (ro, re_)) in enumerate(ro_re_)

        ro_[idr] = ro

        for (fl, re) in zip(fl_, re_)

            rre = Regex(re)

            for (idc, co) in enumerate(co_)

                if contains(co, rre)

                    ro_x_co_x_fl[idr, idc] = fl

                end

            end

        end

    end

    ro_, ro_x_co_x_fl

end

end
