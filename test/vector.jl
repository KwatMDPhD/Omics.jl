TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

for ve_ in [
    [[], []],
    [[1], [1, 2]],
    [[1.0], [1.0, 2.0]],
    [['a'], ['a', 'b']],
    [["a"], ["a", "b"]],
    [[1, 2, 3], [1, 4, 5]],
]

    println(OnePiece.extension.vector.get_longest_common_prefix(ve_))

end

OnePiece.extension.vector.get_longest_common_prefix(["abc", "abcd", "a"])

ca_ = collect("A23456789XJQK")

st1_ = ['1', '2', 'K']

;

OnePiece.extension.vector.is_in(ca_, st1_)

ca_id = Dict(ca => id for (id, ca) in enumerate(ca_))

OnePiece.extension.vector.is_in(ca_id, st1_)

ve_ = [['a', 'e', 'K', 't'], ["a", "K", "t", "w"]]

OnePiece.extension.vector.sort_like([[2, 4, 1, 3], ve_...])

OnePiece.extension.vector.sort_like([[3, 1, 4, 2], ve_...])

al_ = collect("abcdefghijklmnopqrstuvwxyz")

OnePiece.extension.vector.get_order(al_, "aiko!")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
