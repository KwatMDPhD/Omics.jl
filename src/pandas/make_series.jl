using DataFrames: DataFrameRow
using PyCall: @py_str, PyObject

function make_series(ro::DataFrameRow)::PyObject

    py"""
    from pandas import Series
    """

    na_ = names(ro)

    return py"Series"(data = ro[2:end], index = na_[2:end], name = ro[1])

end

export make_series
