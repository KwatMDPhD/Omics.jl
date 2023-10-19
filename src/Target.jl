module Target

function _un(an_)

    sort!(unique(an_))

end

function _ma(an_)

    Dict(an => id for (id, an) in enumerate(an_))

end

function tabulate(ro_)

    rou_ = _un(ro_)

    ro_x_id_x_is = falses(lastindex(rou_), lastindex(ro_))

    ro_id = _ma(rou_)

    for (id, ro) in enumerate(ro_)

        ro_x_id_x_is[ro_id[ro], id] = true

    end

    rou_, ro_x_id_x_is

end

function tabulate(ro___, co___, fl_)

    ro_ = zip(ro___...)

    co_ = zip(co___...)

    rou_ = _un(ro_)

    cou_ = _un(co_)

    ro_x_co_x_fl = fill(NaN, lastindex(rou_), lastindex(cou_))

    ro_id = _ma(rou_)

    co_id = _ma(cou_)

    for (ro, co, fl) in zip(ro_, co_, fl_)

        ro_x_co_x_fl[ro_id[ro], co_id[co]] = fl

    end

    join.(rou_, '_'), join.(cou_, '_'), ro_x_co_x_fl

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
