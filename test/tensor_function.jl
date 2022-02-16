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

ma = convert(Matrix, reshape(1:(n_ro * n_co), (n_ro, n_co)))

OnePiece.tensor_function.apply(te, te, .-)

OnePiece.tensor_function.apply(bi_, te, .-)

OnePiece.tensor_function.apply(te, ma, .*)

OnePiece.tensor_function.apply(bi_, ma, .+)

OnePiece.tensor_function.apply(ma, ma, (ro1, ro2) -> minimum([ro1; ro2]))

for i in [1, 2], j in [10, 20]

    println(i, " ", j)

end

for i in [1, 2]

    for j in [10, 20]

        println(i, " ", j)

    end

end

ma2 = [
    1 10 100 1000
    0.001 0.0 1 0.1
]

ma1 = [
    0 0 1 1
    -1 0 1 2
]

OnePiece.tensor_function.apply(ma1, ma2, .+)

ma1 = convert(
    BitMatrix,
    [
        0 0 1 1
        1 1 0 0
    ],
)

OnePiece.tensor_function.apply(ma1, ma2, .-)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
