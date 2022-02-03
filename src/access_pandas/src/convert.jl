function convert(da::DataFrames.DataFrame)::PyObject

    py"""
    from pandas import DataFrame
    """

    si2 = size(da)[2]

    if 1 < si2

        id_ = 2:si2

    else

        error("dataframe does not have at least 2 columns.")

    end

    na_ = names(da)

    da = py"DataFrame"(data = Matrix(da[!, id_]), index = da[!, 1], columns = na_[id_])

    da.index.name = na_[1]

    return da

end

function convert(da::PyObject)::DataFrames.DataFrame

    return DataFrames.DataFrame(reset_index(Pandas.DataFrame(da)))

end

function convert(ro::DataFrameRow)::PyObject

    na_ = names(ro)

    return make_series(na_[1], na_[2:end], string(ro[1]), Vector(ro[2:end]))

end
