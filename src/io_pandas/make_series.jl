using PyCall: @py_str, PyObject

function make_series(id::String, id_::Vector, da::String, da_::Vector)::PyObject

    py"""
    from pandas import Series
    """

    se = py"Series"(data = da_, index = id_, name = da)

    se.index.name = id

    return se

end
