# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "path.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

println("-"^99)

println("shorten")

println("-"^99)

pa = @__DIR__

println("pa=$pa")

try

    OnePiece.path.shorten(pa, "Shanks")

catch er

    println(er)

end


for n_ba in [2, 1]

    println("-"^99)

    println("n_ba=$n_ba")

    println(OnePiece.path.shorten(pa, n_ba))

end

for di in ["OnePiece.jl", "test", "OnePiece.jl/test"]

    println("-"^99)

    println("di=$di")

    println(OnePiece.path.shorten(pa, di))

    for sh in [-1, 1]

        println("sh=$sh")

        println(OnePiece.path.shorten(pa, di, sh = sh))

    end

end

# ----------------------------------------------------------------------------------------------- #
OnePiece.path.clean("a_b.c-d+e!f%g%h]iJK")

# ----------------------------------------------------------------------------------------------- #
for pa in ["~/file", "~/directory/"]

    println(OnePiece.path.make_absolute(pa))

end

# ----------------------------------------------------------------------------------------------- #
OnePiece.path.remove_extension("/path/to/a/file.extension")

OnePiece.path.remove_extension("/path/to/a/file")

OnePiece.path.remove_extension("/path/to/a/directory/")

# ----------------------------------------------------------------------------------------------- #
di = homedir()

OnePiece.path.select(di)

OnePiece.path.select(di, ig_ = [], ke_ = [r"^\."], jo = false)

# ----------------------------------------------------------------------------------------------- #
go = "test/path.jl"

OnePiece.path.error_missing(dirname(@__DIR__), [go])

try

    OnePiece.path.error_missing(dirname(@__DIR__), [go, "missing/file", "missing/directory/"])

catch er

    println(er)

end

OnePiece.path.error_extension("file.extension", ".extension")

for ex in ["extension", ".another_extension"]

    try

        OnePiece.path.error_extension("file.extension", ex)

    catch er

        println(er)

    end

end

# ----------------------------------------------------------------------------------------------- #
te = joinpath(TE, "move")

di1 = mkpath(joinpath(te, "di1"))

di2 = mkpath(joinpath(te, "di2"))

di3 = mkpath(joinpath(te, "di3"))

fi1 = joinpath(di1, "fi1")

fi2 = joinpath(di2, "fi2")

touch(fi1)

touch(fi2)

run(`tree $te`)

fi12 = replace(fi1, "di1" => "di3")

println(OnePiece.path.move(fi1, fi12))

run(`tree $te`)

try

    OnePiece.path.move(di2, di3)

catch er

    println(er)

end

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.path.move(di2, di3, force = true))

run(`tree $te`)

# ----------------------------------------------------------------------------------------------- #
fi1 = joinpath(te, "fi1")

fi2 = joinpath(te, "fi2")

open(fi1, "w") do io

    write(io, "Before")

end

open(fi2, "w") do io

    write(io, "BeforeBefore")

end

println(readline(open(fi1)))

println(readline(open(fi2)))

OnePiece.path.sed_recursively(te, ["Before" => "After"])

println(readline(open(fi1)))

println(readline(open(fi2)))

# ----------------------------------------------------------------------------------------------- #
println("Done.")
