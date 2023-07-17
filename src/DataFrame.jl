module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using BioLab

#function make(co_, ve_)
#
#    _DataFrame(BioLab.Matrix.make(ve_), co_)
#
#end
#
function make(nar, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, nar => ro_)

end

function separate(da)

    co_ = names(da)

    id_ = 2:length(co_)

    co_[1], da[:, 1], view(co_, id_), Matrix(da[!, id_])

end

end
