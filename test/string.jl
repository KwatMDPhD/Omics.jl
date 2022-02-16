# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
for st in ["aa", "DNA", "Hello world!", "SARS-COVID-2"]

    println("$st ==> $(OnePiece.string.title(st))")

end

# ----------------------------------------------------------------------------------------------- #
for st_ in [
    ["", "", ""],
    ["kate"],
    ["kate", "katana"],
    ["kate", "kwat"],
    ["kate", "kwat", "kazakh"],
    ["a", "ab", "abc"],
    ["abc", "ab", "a"],
]

    println(OnePiece.string.remove_longest_common_prefix(st_))

end

# ----------------------------------------------------------------------------------------------- #
st1 = "A--BB--CCC"

st2 = "a--bb--ccc"

de = "--"

OnePiece.string.transplant(st1, st2, de, [1, 2, 1])

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
