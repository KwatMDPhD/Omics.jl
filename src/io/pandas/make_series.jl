function make_series(id, id_, da, da_)

    py"""
    from pandas import Series
    """

    se = py"Series"(data = da_, index = id_, name = da)

    se.index.name = id

    return se

end

function make_series(ro)

    na_ = names(ro)

    return make_series(na_[1], na_[2:end], string(ro[1]), collect(ro[2:end]))

end
