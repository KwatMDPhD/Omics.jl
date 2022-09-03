# TODO: merge with `separate_row`
function separate(da)

    ri = da[!, 2:end]

    da[!, 1], names(ri), Matrix(ri)

end
