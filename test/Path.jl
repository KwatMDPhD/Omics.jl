using Test: @test

using BioLab

# ---- #

BioLab.Path.wait("missing_file")

# ---- #

const NA = "a_b.c-d+e!f%g%h]iJK"

const NAC = "a_b.c_d_e_f_g_h_ijk"

for (pa, re) in ((NA, NAC), (joinpath("\$", NA), joinpath("_", NAC)))

    @test BioLab.Path.clean(pa) == re

end

# ---- #

BioLab.Path.open(BioLab.TE)

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

const DI2 = mkdir(joinpath(BioLab.TE, BioLab.Time.stamp()))

const CH_ = 'a':'g'

const EX = "extension"

for (nu, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), CH_)

    touch(joinpath(DI2, "$nu.$ch.$EX"))

end

BioLab.Path.rank(DI2)

@test BioLab.Path.read(DI2) == ["$id.$ch.$EX" for (id, ch) in enumerate(CH_)]
