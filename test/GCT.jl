using Test: @test

using BioLab

# ---- #

DA = joinpath(BioLab.DA, "GCT")

# ---- #

@test readdir(DA) == ["a.gct"]

# ---- #

@test size(BioLab.GCT.read(joinpath(DA, "a.gct"))) == (13321, 190)
