using DataFrames: DataFrame
using PyCall: @py_str, PyObject
function make_dataframe(da::DataFrame)::PyObject

    py"""
    from pandas import DataFrame
    """

    ie_ = 2:size(da)[2]-1

    return py"DataFrame"(
        data = Matrix(da[!, ie_]),
        index = da[!, 1],
        columns = names(da)[ie_],
    )

end

export make_dataframe
