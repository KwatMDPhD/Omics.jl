using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "GCT")

# ---- #

@test BioLab.Path.read(DA) == ["a.gct"]

# ---- #

const GC = joinpath(DA, "a.gct")

# ---- #

@test size(BioLab.GCT.read(GC)) === (13321, 190)

# ---- #

# 97.734 ms (71117 allocations: 23.64 MiB)
#@btime BioLab.GCT.read(GC);
