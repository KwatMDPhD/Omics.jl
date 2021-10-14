using DataFrames: DataFrame
using Pandas: DataFrame as Pandas_DataFrame, reset_index
using PyCall: @py_str, PyObject

function make_dataframe(da::DataFrame)::PyObject

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

    da = py"DataFrame"(
        data = Matrix(da[!, id_]),
        index = da[!, 1],
        columns = na_[id_],
    )

    da.index.name = na_[1]

    return da

end

function make_dataframe(da::PyObject)::DataFrame

    return DataFrame(reset_index(Pandas_DataFrame(da)))

end

export make_dataframe
