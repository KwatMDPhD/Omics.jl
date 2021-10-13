using DataFrames: DataFrameRow
using PyCall: @py_str, PyObject

function make_series(
    nai::String,
    ie_::Vector,
    nad::String,
    da_::Vector,
)::PyObject

    py"""
    from pandas import Series
    """

    se = py"Series"(data = da_, index = ie_, name = nad)

    se.index.name = nai

    return se

end

function make_series(ro::DataFrameRow)::PyObject

    na_ = names(ro)

    return make_series(na_[1], na_[2:end], string(ro[1]), Vector(ro[2:end]))

end

export make_series
