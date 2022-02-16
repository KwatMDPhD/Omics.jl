# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "vector.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
for ve_ in [
    [[], []],
    [[1], [1, 2]],
    [[1.0], [1.0, 2.0]],
    [['a'], ['a', 'b']],
    [["a"], ["a", "b"]],
    [[1, 2, 3], [1, 4, 5]],
]

    println(OnePiece.vector.get_longest_common_prefix(ve_...))

end

println(OnePiece.vector.get_longest_common_prefix("abc", "abcd", "a"))

# ----------------------------------------------------------------------------------------------- #
ca_ = collect("A23456789XJQK")

st1_ = ['1', '2', 'K']

println(OnePiece.vector.is_in(ca_, st1_))

ca_id = Dict(ca => id for (id, ca) in enumerate(ca_))

println(OnePiece.vector.is_in(ca_id, st1_))

# ----------------------------------------------------------------------------------------------- #
ve1 = ['a', 'e', 'K', 't']

ve2 = ["a", "K", "t", "w"]

OnePiece.vector.sort_like([2, 4, 1, 3], ve1, ve2)

OnePiece.vector.sort_like([3, 1, 4, 2], ve1, ve2)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
