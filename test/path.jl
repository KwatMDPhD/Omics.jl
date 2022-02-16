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

# ----------------------------------------------------------------------------------------------- #
pa = pwd()

try

    OnePiece.extension.path.shorten(pa, "Shanks")

catch er

    er

end

for n_ba in [2, 1]

    println(OnePiece.extension.path.shorten(pa, n_ba))

end

for di in ["OnePiece.jl", "test", "OnePiece.jl/test", "extension"]

    println(OnePiece.extension.path.shorten(pa, di))

end

OnePiece.extension.path.clean("a_b.c-d+e!f%g%h]iJK")

for pa in ["~/file", "~/directory/"]

    println(OnePiece.extension.path.make_absolute(pa))

end

OnePiece.extension.path.remove_extension("/path/to/a/file.extension")

OnePiece.extension.path.remove_extension("/path/to/a/file")

OnePiece.extension.path.remove_extension("/path/to/a/directory/")

di = homedir()

;

OnePiece.extension.path.select(di)

OnePiece.extension.path.select(di; ig_ = [], ke_ = [r"^\."], jo = false)

go = "extension/path.ipynb"

OnePiece.extension.path.error_missing_path(dirname(@__DIR__), [go])

try

    OnePiece.extension.path.error_missing_path(
        dirname(@__DIR__),
        [go, "missing/file", "missing/directory/"],
    )

catch er

    er

end

OnePiece.extension.path.error_extension("file.extension", ".extension")

for ex in ["extension", ".another_extension"]

    try

        OnePiece.extension.path.error_extension("file.extension", ex)

    catch er

        println(er)

    end

end

te = joinpath(tempdir(), "move")

di1 = mkpath(joinpath(te, "di1"))

di2 = mkpath(joinpath(te, "di2"))

di3 = mkpath(joinpath(te, "di3"))

fi1 = joinpath(di1, "fi1")

fi2 = joinpath(di2, "fi2")

touch(fi1)

touch(fi2)

run(`tree $te`)

;

fi12 = replace(fi1, "di1" => "di3")

println(OnePiece.extension.path.move(fi1, fi12))

run(`tree $te`)

;

try

    OnePiece.extension.path.move(di2, di3)

catch er

    er

end

println(OnePiece.extension.path.move(di2, di3; fo = true))

run(`tree $te`)

;

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

;

OnePiece.extension.path.sed_recursively(te, ["Before" => "After"])

println(readline(open(fi1)))

println(readline(open(fi2)))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
