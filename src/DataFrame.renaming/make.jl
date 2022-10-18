function make(va__)

    co_ = va__[1]

    DataFrames.DataFrame([va__[idr][idc] for idr in 2:length(va__), idc in 1:length(co_)], co_)

end

function make(na, ro_, co_, ma)

    insertcols!(DataFrames.DataFrame(ma, co_), 1, na => ro_)

end
