module Target

# TODO: Consider moving to Collection.
function _unique_sort(an_)

    sort!(unique(an_))

end

# TODO: Consider moving to Collection.
function _map_index(un_)

    Dict(un => id for (id, un) in enumerate(un_))

end

function tabulate(ro_)

    rou_ = _unique_sort(ro_)

    ro_x_id_x_is = falses(length(rou_), length(ro_))

    ro_id = _map_index(rou_)

    for (id, ro) in enumerate(ro_)

        ro_x_id_x_is[ro_id[ro], id] = true

    end

    rou_, ro_x_id_x_is

end

function tabulate(ro___, co___, fi, an_)

    ro_ = zip(ro___...)

    co_ = zip(co___...)

    rou_ = _unique_sort(ro_)

    cou_ = _unique_sort(co_)

    ro_x_co_x_an = fill(fi, length(rou_), length(cou_))

    ro_id = _map_index(rou_)

    co_id = _map_index(cou_)

    for (ro, co, an) in zip(ro_, co_, an_)

        ro_x_co_x_an[ro_id[ro], co_id[co]] = an

    end

    join.(rou_, '_'), join.(cou_, '_'), ro_x_co_x_an

end

end
