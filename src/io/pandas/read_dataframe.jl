function read_dataframe(py)

    py = py.reset_index()

    return convert.(PyAny, DataFrame(py.values, string.(py.columns)))

end
