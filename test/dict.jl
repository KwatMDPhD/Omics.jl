# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "dict.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
OnePiece.dict.view(Dict())

# ----------------------------------------------------------------------------------------------- #
OnePiece.dict.view(OnePiece.dict.make(a = 1, b = [2], c = Dict("d" => 3)), id = 2)

# ----------------------------------------------------------------------------------------------- #
OnePiece.dict.summarize(Dict(1 => "a", 2 => "a", 3 => "b", 4 => nothing, 5 => nothing, 6 => NaN))

# ----------------------------------------------------------------------------------------------- #
di = Dict(
    "z" => Dict("c" => 1, "b" => 2, "a" => 3),
    "y" => Dict(),
    "x" => [3, 2, 1, Dict("zo" => 2, "lu" => 1)],
    "w" => [Dict("k" => 8, "j" => 24), Dict("lo" => 1, "la" => 3)],
)

OnePiece.dict.view(OnePiece.dict.sort_recursively!(di))

# ----------------------------------------------------------------------------------------------- #
di1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

di2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

OnePiece.dict.view(OnePiece.dict.merge(di1, di2))

OnePiece.dict.view(OnePiece.dict.merge(di2, di1))

# ----------------------------------------------------------------------------------------------- #
da = joinpath(@__DIR__, "dict.data")

OnePiece.dict.view(OnePiece.dict.read(joinpath(da, "example_1.json")))

OnePiece.dict.view(OnePiece.dict.read(joinpath(da, "example_2.json")))

OnePiece.dict.view(OnePiece.dict.read(joinpath(da, "example.toml")))

# ----------------------------------------------------------------------------------------------- #
js = joinpath(TE, "write.json")

di = Dict(
    "Luffy" => "Pirate King",
    "Crews" => [
        "Luffy",
        "Zoro",
        "Nami",
        "Usopp",
        "Sanji",
        "Chopper",
        "Robin",
        "Franky",
        "Brook",
        "Jinbe",
    ],
    "episode" => 1030,
)

OnePiece.dict.write(js, di)

OnePiece.dict.view(OnePiece.dict.read(js))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
