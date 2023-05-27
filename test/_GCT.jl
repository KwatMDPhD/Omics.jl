include("environment.jl")

# ---- #

gc = joinpath(@__DIR__, "GCT.data", "a.gct")

#TODO: `@test`.
display(BioLab.GCT.read(gc))

# @code_warntype BioLab.GCT.read(gc)

# 87.198 ms (84878 allocations: 24.68 MiB)
# @btime BioLab.GCT.read($gc)
