using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "GCT")

# ---- #

@test Nucleus.Path.read(DA) == ["a.gct"]

# ---- #

const GC = joinpath(DA, "a.gct")

# ---- #

@test size(Nucleus.GCT.read(GC)) === (13321, 190)

# ---- #

# 97.734 ms (71117 allocations: 23.64 MiB)
#@btime Nucleus.GCT.read(GC);
