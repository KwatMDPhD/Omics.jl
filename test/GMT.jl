include("environment.jl")

# ---- #

da = joinpath(BioLab.DA, "GMT")

for (na, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    @test length(BioLab.GMT.read(joinpath(da, na))) == re

end
