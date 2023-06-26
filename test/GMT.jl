include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "GMT")

# ---- #

for (na, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    @test length(BioLab.GMT.read(joinpath(DA, na))) == re

end
