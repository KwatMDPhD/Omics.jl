function make_dataframe(da)

    py"""
    from pandas import DataFrame
    """

    si2 = size(da)[2]

    if 1 < si2

        co_ = 2:si2

    else

        error()

    end

    na_ = names(da)

    py = py"DataFrame"(data = Matrix(da[!, co_]), index = da[!, 1], columns = na_[co_])

    py.index.name = na_[1]

    py

end
