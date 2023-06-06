include("environment.jl")

# ---- #

bi = dirname(@__DIR__)

jl = dirname(bi)

ho = homedir()

# ---- #

for (paf, pat) in
    (("a/b", "a"), ("a", "a/b"), ("a/b/c", "a/b/c/d"), ("a/b/c", "a/b/C/d"), ("a/b", "x/y"))

    BioLab.Path.print_change(paf, pat)

end

# ---- #

wo = pwd()

for (pa, re) in (
    ("~/file", "$ho/file"),
    ("~/directory/", "$ho/directory"),
    ("~/path/directory/", "$ho/path/directory"),
    (".", wo),
    ("..", dirname(wo)),
    ("../..", dirname(dirname(wo))),
)

    @test BioLab.Path.make_absolute(pa) == re

end

# ---- #

@test @is_error BioLab.Path.shorten(@__DIR__, "Shanks")

# ---- #

for (sh, re) in
    ((-1, "BioLab.jl/test"), (0, "test"), (1, "test"), (-count('/', @__DIR__), @__DIR__))

    @test BioLab.Path.shorten(@__DIR__, sh) == re

end

# ---- #

for (di, sh, re) in (
    ("BioLab.jl", -1, "$(basename(jl))/BioLab.jl/test"),
    ("BioLab.jl", 0, "BioLab.jl/test"),
    ("BioLab.jl", 1, "test"),
    ("test", -1, "BioLab.jl/test"),
    ("test", 0, "test"),
    ("test", 1, "test"),
    ("BioLab.jl/test", -1, "BioLab.jl/test"),
    ("BioLab.jl/test", 0, "test"),
    ("BioLab.jl/test", 1, "test"),
)

    @test BioLab.Path.shorten(@__DIR__, di; sh) == re

end

# ---- #

fi = "file.extension"

for ex in ("extension", ".another_extension")

    @test @is_error BioLab.Path.error_extension(fi, ex)

end

# ---- #

BioLab.Path.error_extension(fi, ".extension")

# ---- #

@test BioLab.Path.replace_extension(fi, "new_extension") == "file.new_extension"

# ---- #

@test BioLab.Path.clean("d/a_b.c-d+e!f%g%h]iJK") == "d/a_b.c_d_e_f_g_h_ijk"

# ---- #

@test @is_error BioLab.Path.error_missing(bi, "missing/file")

# ---- #

for re in ("test/Path.jl", "test/path.jl")

    @test !@is_error BioLab.Path.error_missing(bi, re)

end

# ---- #

display(BioLab.Path.read(ho))

# ---- #

display(BioLab.Path.read(ho; join = false, ig_ = (), ke_ = (r"^\.",)))

# ---- #

display(BioLab.Path.read(ho; ke_ = (r"^[A-Z]",)))

# ---- #

te = joinpath(tempdir(), "BioLab.test.Path")

BioLab.Path.reset(te)

touch(joinpath(te, "touch"))

@test BioLab.Path.read(BioLab.Path.reset(te)) == []

# ---- #

ra = mkdir(joinpath(te, "rank"))

ex = "extension"

for (nu, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), 'a':'z')

    touch(joinpath(ra, "$nu.$ch.$ex"))

end

BioLab.Path.rank(ra)

@test BioLab.Path.read(ra) == ["$id.$ch.$ex" for (id, ch) in enumerate('a':'g')]

# ---- #

fi1 = touch(joinpath(te, "fi1"))

fi2 = touch(joinpath(te, "fi2"))

BioLab.Path.rename_recursively(te, ("fi" => "new",))

@test BioLab.Path.read(te) == ["new1", "new2", "rank"]

# ---- #

fi1 = touch(joinpath(te, "fi1"))

write(fi1, "Before")

fi2 = touch(joinpath(te, "fi2"))

write(fi2, "BeforeBefore")

BioLab.Path.sed_recursively(te, ("Before" => "After",))

@test readline(open(fi1)) == "After"

@test readline(open(fi2)) == "AfterAfter"
