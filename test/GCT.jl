include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "GCT")

# ---- #

@test size(BioLab.GCT.read(joinpath(DA, "a.gct"))) == (13321, 190)
