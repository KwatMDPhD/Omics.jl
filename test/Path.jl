include("_.jl")

# ---- #

ho = homedir()

# ---- #

for (pa, re) in (
    ("~/file", "$ho/file"),
    ("~/directory/", "$ho/directory"),
    ("~/path/directory/", "$ho/path/directory"),
    # (".", "$ho/$/BioLab.jl/test"),
    # ("..", "$ho/$/BioLab.jl"),
    # ("../..", "$ho/$"),
)

    BioLab.print_header(pa)

    @test BioLab.Path.make_absolute(pa) == re

    # @code_warntype BioLab.Path.make_absolute(pa)

    # 657.154 ns (14 allocations: 1.27 KiB)
    # 816.284 ns (15 allocations: 1.31 KiB)
    # 947.435 ns (15 allocations: 1.35 KiB)
    # 7.271 μs (16 allocations: 1.49 KiB)
    # 7.271 μs (15 allocations: 1.34 KiB)
    # 7.271 μs (15 allocations: 1.32 KiB)
    # @btime BioLab.Path.make_absolute($pa)

end

# ---- #

pa = @__DIR__

@test @is_error BioLab.Path.shorten(pa, "Shanks")

for (n, re) in (
    (0, "test"),
    (1, "BioLab.jl/test"),
    # (2, "$/BioLab.jl/test"),
    # (9, "$ho/$/BioLab.jl/test"),
)

    @test BioLab.Path.shorten(pa, n) == re

end

n = 2

# @code_warntype BioLab.Path.shorten(pa, n)

# 1.767 μs (75 allocations: 3.30 KiB)
# @btime BioLab.Path.shorten($pa, $n)

# ---- #

for di in ("BioLab.jl", "test", "BioLab.jl/test")

    for sh in (0, -1, 1)

        BioLab.print_header("$di $sh")

        # TODO: @test.
        display(BioLab.Path.shorten(pa, di; sh))

    end

end

# @code_warntype BioLab.Path.shorten(pa, ho)

# 3.432 μs (144 allocations: 6.36 KiB)
# @btime BioLab.Path.shorten($pa, $ho)

# ---- #

pa = "d/a_b.c-d+e!f%g%h]iJK"

@test BioLab.Path.clean(pa) == "d/a_b.c_d_e_f_g_h_ijk"

# @code_warntype BioLab.Path.clean(pa)

# TODO: Time.
# @btime BioLab.Path.clean($pa; pr = $false)

# ---- #

fi = "file.extension"

for ex in ("extension", ".another_extension")

    @test @is_error BioLab.Path.error_extension(fi, ex)

end

ex = ".extension"

@test !@is_error BioLab.Path.error_extension(fi, ex)

# @code_warntype BioLab.Path.error_extension(fi, ex)

# TODO: Time.
# @btime BioLab.Path.error_extension($fi, $ex)

# ---- #

ex = "new_extension"

@test BioLab.Path.replace_extension(fi, ex) == "file.new_extension"

# @code_warntype BioLab.Path.replace_extension(fi, ex)

# 243.240 ns (12 allocations: 528 bytes)
# @btime BioLab.Path.replace_extension($fi, $ex)

# ---- #

di = dirname(@__DIR__)

@test @is_error BioLab.Path.error_missing(di, (pr, "missing/file", "missing/directory/"))

for pr in ("test/Path.jl", "test/path.jl")

    @test !@is_error BioLab.Path.error_missing(di, pr)

end

pa_ = ("Project.toml", "Manifest.toml")

# @code_warntype BioLab.Path.error_missing(di, pa_)

# 3.146 μs (6 allocations: 640 bytes)
# @btime BioLab.Path.error_missing($di, $pa_)

# ---- #

# TODO: `@test`.
display(BioLab.Path.list(ho))

# TODO: `@test`.
display(BioLab.Path.list(ho; jo = false, ig_ = (), ke_ = (r"^\.",)))

ke_ = (r"^[A-Z]",)

# TODO: `@test`.
display(BioLab.Path.list(ho; ke_))

# @code_warntype BioLab.Path.list(ho; ke_)

# 20.750 μs (37 allocations: 1.56 KiB)
# @btime BioLab.Path.list($ho; ke_ = $ke_)

# ---- #

te = joinpath(tempdir(), "BioLab.test.Path")

BioLab.Path.empty(te)

# TODO
dip = mkpath(joinpath(tempdir(), "Present"))
BioLab.Path.empty(dip)
@test isdir(dip) && length(readdir(dip)) == 0
dia = joinpath(tempdir(), "Absent")
BioLab.Path.empty(dia)
@test isdir(dia) && length(readdir(dia)) == 0
@code_warntype BioLab.Path.empty(dia)

# ---- #

di1 = mkpath(joinpath(te, "di1"))

fi1 = touch(joinpath(di1, "fi1"))

di2 = mkpath(joinpath(te, "di2"))

fi2 = touch(joinpath(di2, "fi2"))

di3 = mkpath(joinpath(te, "di3"))

run(`tree $te`)

BioLab.Path.move(fi1, replace(fi1, "di1" => "di3"))

# TODO: `@test`.
run(`tree $te`)

@test @is_error BioLab.Path.move(di2, di3)

@test !@is_error BioLab.Path.move(di2, di3; force = true)

# TODO: `@test`.
run(`tree $te`)

# @code_warntype BioLab.Path.move(di2, di3; force = true)

# ---- #

ra = mkdir(joinpath(te, "rank"))

for (pr, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), 'a':'z')

    touch(joinpath(ra, "$pr.$ch.jl"))

end

run(`tree $ra`)

BioLab.Path.rank(ra)

# TODO: `@test`.
run(`tree $ra`)

# @code_warntype BioLab.Path.rank(ra)

# ---- #

fi1 = touch(joinpath(te, "fi1"))

fi2 = touch(joinpath(te, "fi2"))

run(`tree $te`)

pa_ = ("fi" => "new",)

BioLab.Path.rename_recursively(te, pa_)

# TODO: `@test`.
run(`tree $te`)

# @code_warntype BioLab.Path.rename_recursively(te, pa_)

# ---- #

fi1 = touch(joinpath(te, "fi1"))

write(fi1, "Before")

fi2 = touch(joinpath(te, "fi2"))

write(fi2, "BeforeBefore")

pa_ = ("Before" => "After",)

BioLab.Path.sed_recursively(te, pa_)

@test readline(open(fi1)) == "After"

@test readline(open(fi2)) == "AfterAfter"

# @code_warntype BioLab.Path.sed_recursively(te, pa_)
