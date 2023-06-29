include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "GCT")

@test readdir(DA) == []

# ---- #

@test size(BioLab.GCT.read(joinpath(DA, "a.gct"))) == (13321, 190)
