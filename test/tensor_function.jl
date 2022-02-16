# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "tensor_function.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
n_ro = 5

n_co = 4

n_ze = convert(Int64, n_co / 2)

n_on = n_co - n_ze

bi_ = convert(BitVector, [zeros(n_ze); ones(n_on)])

te = [10^(id - 1) for id in 1:n_co]

ma = OnePiece.tensor.simulate(n_ro, n_co)

println(OnePiece.tensor_function.apply(te, te, .-))

println(OnePiece.tensor_function.apply(bi_, te, .-))

println(OnePiece.tensor_function.apply(te, ma, .*))

println(OnePiece.tensor_function.apply(bi_, ma, .+))

println(OnePiece.tensor_function.apply(ma, ma, (ro1, ro2) -> minimum([ro1; ro2])))

ma2 = [
    1 10 100 1000
    0.001 0.0 1 0.1
]

ma1 = [
    0 0 1 1
    -1 0 1 2
]

println(OnePiece.tensor_function.apply(ma1, ma2, .+))

ma1 = convert(
    BitMatrix,
    [
        0 0 1 1
        1 1 0 0
    ],
)

println(OnePiece.tensor_function.apply(ma1, ma2, .-))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
