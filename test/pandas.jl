# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "pandas.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
n_ro = 3

da = DataFrame("Index" => [string("Index ", id) for id in 1:n_ro])

try

    OnePiece.pandas.convert(da)

catch er

    er

end

da[!, "Column 1"] = 1:n_ro

da

py = OnePiece.pandas.make_dataframe(da)

da = OnePiece.pandas.read_dataframe(py)

da[!, "Column 2"] = convert(Vector{Float64}, da[!, "Column 1"])

da

py = OnePiece.pandas.make_dataframe(da)

da = OnePiece.pandas.read_dataframe(py)

da[!, "Column 3"] = string.(da[!, "Column 1"])

da

py = OnePiece.pandas.make_dataframe(da)

da = OnePiece.pandas.read_dataframe(py)

n_va = 4

OnePiece.pandas.make_series("Index", [string("Index ", id) for id in 1:n_va], "Data", rand(n_va))

for da_ in [[1, 1.0, 1 / 1, 1 // 1], [1, 1.0, "1"], [1, 1.0, nothing], [1, 1.0, NaN]]

    println('-'^99)

    println(OnePiece.pandas.make_series("Index", da_, "Data", da_))

end

n_ro = 1

da = DataFrame("Index" => [string("Index ", id) for id in 1:n_ro], "Column 1" => 1:n_ro)

OnePiece.pandas.make_series(da[1, :])

da[!, "Column 2"] = convert(Vector{Float64}, da[!, "Column 1"])

da

OnePiece.pandas.make_series(da[1, :])

da[!, "Column 3"] = string.(da[!, "Column 1"])

da

OnePiece.pandas.make_series(da[1, :])

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
