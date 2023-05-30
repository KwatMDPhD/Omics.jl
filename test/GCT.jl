include("environment.jl")

# ---- #

@test size(BioLab.GCT.read(joinpath(DA, "GCT", "a.gct"))) == (13321, 190)
