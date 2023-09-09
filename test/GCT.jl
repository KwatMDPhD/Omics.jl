using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "GCT")

@test BioLab.Path.read(DA) == ["a.gct"]

# ---- #

@test size(BioLab.GCT.read(joinpath(DA, "a.gct"))) == (13321, 190)
