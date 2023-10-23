using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is Nucleus.Path.clean(@__DIR__)

# ---- #

@test Nucleus.Path.clean("a_b.c-d+e!f%g%h]iJK") === "a_b.c_d_e_f_g_h_ijk"

# ---- #

# 444.657 ns (7 allocations: 440 bytes)
#@btime Nucleus.Path.clean("a_b.c-d+e!f%g%h]iJK");

# ---- #

const EX = "extension"

# ---- #

for pa in ("prefix.$EX", "/path/to/prefix.$EX", "s3://path/to/prefix.$EX")

    @test Nucleus.Path.get_extension(pa) === EX

    # 244.123 ns (12 allocations: 520 bytes)
    # 250.791 ns (12 allocations: 528 bytes)
    # 253.944 ns (12 allocations: 536 bytes)
    #@btime Nucleus.Path.get_extension($pa)

end

# ---- #

for sl in (1, 2, 3)

    Nucleus.Path.wait("missing_file", 2; sl)

end

# ---- #

const HO = homedir()

# ---- #

const HI = r"^\."

# ---- #

@test !any(startswith('.'), Nucleus.Path.read(HO; ig_ = (HI,)))

# ---- #

@test all(startswith('.'), Nucleus.Path.read(HO; ke_ = (HI,)))

# ---- #

@test all(na -> isuppercase(na[1]), Nucleus.Path.read(HO; ke_ = (r"^[A-Z]",)))

# ---- #

@test Nucleus.Path.read(HO; ke_ = (r"^Downloads$",)) == ["Downloads"]

# ---- #

@test isempty(Nucleus.Path.read(HO; ig_ = (HI,), ke_ = (HI,)))

# ---- #

Nucleus.Path.open(Nucleus.TE)

# ---- #

function write_file()

    touch(joinpath(Nucleus.TE, "file"))

end

# ---- #

function write_directory()

    mkdir(joinpath(Nucleus.TE, "directory"))

end

# ---- #

for pa in (write_file(), write_directory())

    Nucleus.Path.remove(pa)

    @test Nucleus.Error.@is Nucleus.Path.remove(pa)

end

# ---- #

@test Nucleus.Error.@is Nucleus.Path.remake_directory(write_file())

# ---- #

Nucleus.Path.remake_directory(write_directory())

# ---- #

@test Nucleus.Path.read(Nucleus.TE) == ["directory", "file"]

# ---- #

Nucleus.Path.remake_directory(Nucleus.TE)

# ---- #

@test isempty(Nucleus.Path.read(Nucleus.TE))
