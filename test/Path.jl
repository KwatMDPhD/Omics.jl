using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is Nucleus.Path.clean(@__DIR__)

# ---- #

for (na, re) in (("A_b.C-d+E!f%G%h]IjK", "a_b.c_d_e_f_g_h_ijk"),)

    @test Nucleus.Path.clean(na) === re

    # 443.601 ns (7 allocations: 440 bytes)
    #@btime Nucleus.Path.clean($na)

end

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

for pa in (touch(joinpath(Nucleus.TE, "file")), mkdir(joinpath(Nucleus.TE, "directory")))

    Nucleus.Path.remove(pa)

    @test Nucleus.Error.@is Nucleus.Path.remove(pa)

end
