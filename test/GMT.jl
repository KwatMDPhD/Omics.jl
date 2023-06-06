include("environment.jl")

# ---- #

da = joinpath(pkgdir(BioLab), "data", "GMT")

gm1 = joinpath(da, "h.all.v7.1.symbols.gmt")

le1 = 50

gm2 = joinpath(da, "c2.all.v7.1.symbols.gmt")

le2 = 5529

# ---- #

for (gm, re) in ((gm1, le1), (gm2, le2))

    @test length(BioLab.GMT.read(gm)) == re

end

# ---- #

@test length(merge((BioLab.GMT.read(gm) for gm in (gm1, gm2))...)) == le1 + le2
