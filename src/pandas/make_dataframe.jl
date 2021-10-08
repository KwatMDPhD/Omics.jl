using DataFrames: DataFrame
using PyCall: @py_str, PyObject
using Pandas: reset_index, DataFrame as Pandas_DataFrame

function make_dataframe(da::DataFrame)::PyObject

    py"""
    from pandas import DataFrame
    """

    ie_ = 2:size(da)[2]

    na_ = names(da)

    da = py"DataFrame"(
        data = Matrix(da[!, ie_]),
        index = da[!, 1],
        columns = na_[ie_],
    )

    da.index.name = na_[1]

    return da

end

function make_dataframe(da::PyObject)::DataFrame

    return DataFrame(reset_index(Pandas_DataFrame(da)))

end

export make_dataframe
