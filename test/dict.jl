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
di = OnePiece.dict.make(a = 1, b = [2], c = Dict("d" => 3))

println(di)

# ----------------------------------------------------------------------------------------------- #
OnePiece.dict.view(Dict())

OnePiece.dict.view(di)

OnePiece.dict.view(di, n_pa = 2)

OnePiece.dict.view(di, n_pa = 1, id = 8)

# ----------------------------------------------------------------------------------------------- #
OnePiece.dict.summarize(Dict(1 => "a", 2 => "a", 3 => "b", 4 => nothing, 5 => nothing, 6 => NaN))

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.dict.symbolize(di))

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
println("-"^99)

println("read")

println("-"^99)

da = joinpath(@__DIR__, "dict.data")

js1 = joinpath(da, "example_1.json")

js2 = joinpath(da, "example_2.json")

to = joinpath(da, "example.toml")

OnePiece.dict.view(OnePiece.dict.read(js1))

OnePiece.dict.view(OnePiece.dict.read(js1, js1))

OnePiece.dict.view(OnePiece.dict.read(js2))

OnePiece.dict.view(OnePiece.dict.read(to))

OnePiece.dict.view(OnePiece.dict.read(js1, js2, to))

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
println("Done.")
