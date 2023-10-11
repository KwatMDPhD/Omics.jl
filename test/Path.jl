using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is BioLab.Path.clean(@__DIR__)

# ---- #

@test BioLab.Path.clean("a_b.c-d+e!f%g%h]iJK") === "a_b.c_d_e_f_g_h_ijk"

# ---- #

# 444.657 ns (7 allocations: 440 bytes)
@btime BioLab.Path.clean("a_b.c-d+e!f%g%h]iJK");

# ---- #

const EX = "extension"

# ---- #

for pa in ("prefix.$EX", "/path/to/prefix.$EX", "s3://path/to/prefix.$EX")

    @test BioLab.Path.get_extension(pa) === EX

    # 243.972 ns (12 allocations: 520 bytes)
    # 250.446 ns (12 allocations: 528 bytes)
    # 253.569 ns (12 allocations: 536 bytes)
    @btime BioLab.Path.get_extension($pa)

end

# ---- #

for sl in (1, 2, 3)

    BioLab.Path.wait("missing_file", 2; sl)

end

# ---- #

const HO = homedir()

# ---- #

const HI = r"^\."

# ---- #

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

BioLab.Path.remake_directory(write_directory())

# ---- #

@test BioLab.Path.read(BioLab.TE) == ["directory", "file"]

# ---- #

BioLab.Path.remake_directory(BioLab.TE)

# ---- #

@test isempty(BioLab.Path.read(BioLab.TE))
