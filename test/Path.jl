using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is Nucleus.Path.clean("a/b")

# ---- #

for (na, re) in (("A_b.C-d+E!f%G%h]IjK", "a_b.c_d_e_f_g_h_ijk"),)

    @test Nucleus.Path.clean(na) === re

    # 443.601 ns (7 allocations: 440 bytes)
    #@btime Nucleus.Path.clean($na)

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

for na in ("twice", "twice", "once")

    @test isdir(Nucleus.Path.establish(joinpath(Nucleus.TE, na)))

end
