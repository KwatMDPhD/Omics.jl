using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is BioLab.Path.clean(@__DIR__)

# ---- #

@test BioLab.Path.clean("a_b.c-d+e!f%g%h]iJK") === "a_b.c_d_e_f_g_h_ijk"

# ---- #

const EX = "extension"

for pa in ("prefix.$EX", "/path/to/prefix.$EX", "s3://path/to/prefix.$EX")

    @test BioLab.Path.get_extension(pa) == EX

end

# ---- #

const MA = 2

for sl in (1, 2, 3)

    BioLab.Path.wait("missing_file", MA; sl)

end

# ---- #

const HO = homedir()

const HI = r"^\."

@test !any(startswith('.'), BioLab.Path.read(HO; ig_ = (HI,)))

# ---- #

@test all(startswith('.'), BioLab.Path.read(HO; ke_ = (HI,)))

# ---- #

@test isempty(BioLab.Path.read(HO; ig_ = (HI,), ke_ = (HI,)))

# ---- #

@test all(na -> isuppercase(na[1]), BioLab.Path.read(HO; ke_ = (r"^[A-Z]",)))

# ---- #

@test BioLab.Path.read(HO; ke_ = (r"^Downloads$",)) == ["Downloads"]

# ---- #

BioLab.Path.open(BioLab.TE)

# ---- #

function write_file()

    touch(joinpath(BioLab.TE, "file"))

end

# ---- #

function write_directory()

    mkdir(joinpath(BioLab.TE, "directory"))

end

# ---- #

for pa in (write_file(), write_directory())

    BioLab.Path.remove(pa)

    @test BioLab.Error.@is BioLab.Path.remove(pa)

end

# ---- #

@test BioLab.Error.@is BioLab.Path.remake_directory(write_file())

# ---- #

const DI = BioLab.Path.remake_directory(write_directory())

@test BioLab.Path.read(BioLab.TE) == ["directory", "file"]

# ---- #

const CH_ = 'a':'g'

for (nu, ch) in zip((0.7, 1, 1.1, 3, 10, 12, 24), CH_)

    touch(joinpath(DI, "$nu.$ch.$EX"))

end

@test BioLab.Path.read(BioLab.Path.rank(DI)) == ["$id.$ch.$EX" for (id, ch) in enumerate(CH_)]
