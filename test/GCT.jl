include("environment.jl")

# ---- #

# TODO: `@test`.

da = BioLab.GCT.read(joinpath(DA, "GCT", "a.gct"))

println(first(da, 2))

println(last(da, 2))

@test size(da) == (13321, 190)
