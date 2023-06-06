include("environment.jl")

# ---- #

feature_x_sample_x_number = BioLab.GCT.read(joinpath(DA, "GCT", "a.gct"))

@test size(feature_x_sample_x_number) == (13321, 190)
