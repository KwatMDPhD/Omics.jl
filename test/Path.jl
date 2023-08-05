using Test: @test

using BioLab

# ---- #

const NA = "a_b.c-d+e!f%g%h]iJK"

const NAC = "a_b.c_d_e_f_g_h_ijk"

for (pa, re) in ((NA, NAC), (joinpath("\$", NA), joinpath("_", NAC)))

    @test BioLab.Path.clean(pa) == re

end

# ---- #

BioLab.Path.wait("missing_file")

# ---- #

const HO = homedir()

const HI = r"^\."

@test !any(startswith('.'), BioLab.Path.read(HO; ig_ = (HI,)))

@test all(startswith('.'), BioLab.Path.read(HO; ke_ = (HI,)))

@test isempty(BioLab.Path.read(HO; ig_ = (HI,), ke_ = (HI,)))

@test all(na -> isuppercase(na[1]), BioLab.Path.read(HO; ke_ = (r"^[A-Z]",)))

@test BioLab.Path.read(HO; ke_ = (r"^Downloads$",)) == ["Downloads"]

@test BioLab.Path.read(HO; ke_ = (r"^[A-Z]", r"^Downloads$")) ==
      BioLab.Path.read(HO; ke_ = (r"^[A-Z]",))

# ---- #

const DI1 = BioLab.Path.remake_directory(joinpath(BioLab.TE, "remake_directory"))

const FI = touch(joinpath(DI1, "file"))

@test BioLab.Error.@is_error BioLab.Path.remake_directory(FI)

BioLab.Path.remake_directory(joinpath(DI1, "directory"))

@test readdir(DI1) == ["directory", "file"]

BioLab.Path.remake_directory(DI1)

@test isempty(readdir(DI1))

# ---- #

const DI2 = BioLab.Path.remake_directory(joinpath(BioLab.TE, "rank"))

const CH_ = 'a':'g'

const EX = "extension"

for (nu, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), CH_)

    touch(joinpath(DI2, "$nu.$ch.$EX"))

end

@test BioLab.Path.read(BioLab.Path.rank(DI2)) == ["$id.$ch.$EX" for (id, ch) in enumerate(CH_)]

# ---- #

BioLab.Path.open(BioLab.TE)
