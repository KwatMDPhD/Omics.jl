include("environment.jl")


# ---- #

# TODO
BioLab.Path.warn_overwrite

# ---- #

for pa in ("file", joinpath(@__DIR__, "file"))

    @test @is_error BioLab.Path.error_missing(pa)

end

# ---- #

for pa in ("Path.jl", "path.jl", joinpath(@__DIR__, "Path.jl"), joinpath(@__DIR__, "path.jl"))

    BioLab.Path.error_missing(pa)

end

# ---- #

for pa in ("file.extension", joinpath(@__DIR__, "file.extension"))

    for ex in (".extension", "another_extension")

        @test @is_error BioLab.Path.error_extension_difference(pa, ex)

    end

    BioLab.Path.error_extension_difference(pa, "extension")

end

# ---- #

pk = dirname(@__DIR__)

jl = dirname(pk)

ho = homedir()

for (pa, re) in (
    (".", @__DIR__),
    ("..", pk),
    (joinpath("..", ".."), jl),
    (joinpath("~", "name"), joinpath(ho, "name")),
    (@__DIR__, @__DIR__),
    ((@__DIR__)[2:end], joinpath(@__DIR__, (@__DIR__)[2:end])),
)

    @test BioLab.Path.make_absolute(pa) == re

end

# ---- #

na = "a_b.c-d+e!f%g%h]iJK"

nac = "a_b.c_d_e_f_g_h_ijk"

for (pa, re) in ((na, nac), (joinpath("\$", na), joinpath("_", nac)))

    @test BioLab.Path.clean(pa) == re

end

# ---- #

# TODO
BioLab.Path.wait

# ---- #

for pa in (
    joinpath(BioLab.DA, "CLS", "LPS_phen.cls"),
    joinpath(BioLab.DA, "FeatureSetEnrichment", "genes.txt"),
)

    BioLab.Path.open(pa)

end

# ---- #

@test all(!startswith('.'), BioLab.Path.read(ho))

# ---- #

@test isempty(BioLab.Path.read(ho; ke_ = (r"^\.",)))

# ---- #

@test all(startswith('.'), BioLab.Path.read(ho; ig_ = (), ke_ = (r"^\.",)))

# ---- #

@test all(na -> isuppercase(na[1]), BioLab.Path.read(ho; ke_ = (r"^[A-Z]",)))

# ---- #

@test BioLab.Path.read(ho; ke_ = (r"^Downloads$",)) == ["Downloads"]

# ---- #

@test BioLab.Path.read(ho; ke_ = (r"^[A-Z]", r"^Downloads$")) ==
      BioLab.Path.read(ho; ke_ = (r"^[A-Z]",))

# ---- #

te = joinpath(tempdir(), "BioLab.test.Path")

# ---- #

BioLab.Path.reset(te)

ra = mkdir(joinpath(te, "rank"))

ex = "extension"

for (nu, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), 'a':'z')

    touch(joinpath(ra, "$nu.$ch.$ex"))

end

BioLab.Path.rank(ra)

@test BioLab.Path.read(ra) == ["$id.$ch.$ex" for (id, ch) in enumerate('a':'g')]

# ---- #

BioLab.Path.reset(te)

fi1 = touch(joinpath(te, "fi1"))

fi2 = touch(joinpath(te, "fi2"))

BioLab.Path.rename_recursively(te, ("fi" => "new",))

@test BioLab.Path.read(te) == ["new1", "new2"]

# ---- #

BioLab.Path.reset(te)

fi1 = touch(joinpath(te, "fi1"))

fi2 = touch(joinpath(te, "fi2"))

write(fi1, "Before")

write(fi2, "BeforeBefore")

BioLab.Path.sed_recursively(te, ("Before" => "After",))

@test readline(open(fi1)) == "After"

@test readline(open(fi2)) == "AfterAfter"
