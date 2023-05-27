include("environment.jl")

# ---- #

ho = homedir()

pa = @__DIR__

bi = dirname(pa)

jl = basename(dirname(dirname(pa)))

# ---- #

for (pa, re) in (
    ("~/file", "$ho/file"),
    ("~/directory/", "$ho/directory"),
    ("~/path/directory/", "$ho/path/directory"),
    (".", pa),
    ("..", dirname(pa)),
    ("../..", dirname(dirname(pa))),
)

    BioLab.print_header(pa)

    @test BioLab.Path.make_absolute(pa) == re

end

# ---- #

@test @is_error BioLab.Path.shorten(pa, "Shanks")

# ---- #

for (sh, re) in ((-1, "BioLab.jl/test"), (0, "test"), (1, "test"), (-count('/', pa), pa))

    BioLab.print_header(sh)

    @test BioLab.Path.shorten(pa, sh) == re

end

# ---- #

for (di, sh, re) in (
    ("BioLab.jl", -1, "$jl/BioLab.jl/test"),
    ("BioLab.jl", 0, "BioLab.jl/test"),
    ("BioLab.jl", 1, "test"),
    ("test", -1, "BioLab.jl/test"),
    ("test", 0, "test"),
    ("test", 1, "test"),
    ("BioLab.jl/test", -1, "BioLab.jl/test"),
    ("BioLab.jl/test", 0, "test"),
    ("BioLab.jl/test", 1, "test"),
)

    BioLab.print_header("$di $sh")

    @test BioLab.Path.shorten(pa, di; sh) == re

end

# ---- #

for (paf, pat) in
    (("a/b", "a"), ("a", "a/b"), ("a/b/c", "a/b/c/d"), ("a/b/c", "a/b/C/d"), ("a/b", "x/y"))

    BioLab.Path.print_move(paf, pat)

end

# ---- #

pa = "d/a_b.c-d+e!f%g%h]iJK"

@test BioLab.Path.clean(pa) == "d/a_b.c_d_e_f_g_h_ijk"

# ---- #

fi = "file.extension"

for ex in ("extension", ".another_extension")

    @test @is_error BioLab.Path.error_extension(fi, ex)

end

# ---- #

ex = ".extension"

@test !@is_error BioLab.Path.error_extension(fi, ex)

# ---- #

ex = "new_extension"

@test BioLab.Path.replace_extension(fi, ex) == "file.new_extension"

# ---- #

@test @is_error BioLab.Path.error_missing(bi, "missing/file")

# ---- #

for pr in ("test/Path.jl", "test/path.jl")

    @test !@is_error BioLab.Path.error_missing(bi, pr)

end

# ---- #

display(BioLab.Path.read(ho))

# ---- #

display(BioLab.Path.read(ho; jo = false, ig_ = (), ke_ = (r"^\.",)))

# ---- #

ke_ = (r"^[A-Z]",)

display(BioLab.Path.read(ho; ke_))

# ---- #

te = joinpath(tempdir(), "BioLab.test.Path")

rm(te; force = true, recursive = true)

mkdir(te)

# ---- #

ra = mkpath(joinpath(te, "rank"))

for (pr, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), 'a':'z')

    touch(joinpath(ra, "$pr.$ch.jl"))

end

# ---- #

BioLab.Path.rank(ra)

@test BioLab.Path.readdir(ra) == ["$id.$ch.jl" for (id, ch) in enumerate('a':'g')]

# ---- #

fi1 = touch(joinpath(te, "fi1"))

fi2 = touch(joinpath(te, "fi2"))

display(BioLab.Path.readdir(te))

# ---- #

pa_ = ("fi" => "new",)

# ---- #

BioLab.Path.rename_recursively(te, pa_)

BioLab.Path.readdir(te) == ["new1", "new2", "rank"]

# ---- #

fi1 = touch(joinpath(te, "fi1"))

write(fi1, "Before")

fi2 = touch(joinpath(te, "fi2"))

write(fi2, "BeforeBefore")

pa_ = ("Before" => "After",)

BioLab.Path.sed_recursively(te, pa_)

@test readline(open(fi1)) == "After"

@test readline(open(fi2)) == "AfterAfter"
