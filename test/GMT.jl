include("environment.jl")

# ---- #

da = joinpath(pkgdir(BioLab), "data", "GMT")

gm1 = joinpath(da, "h.all.v7.1.symbols.gmt")

le1 = 50

gm2 = joinpath(da, "c2.all.v7.1.symbols.gmt")

le2 = 5529

# ---- #

for (gm, re) in ((gm1, le1), (gm2, le2))

    BioLab.print_header(gm)

    se_ge_ = BioLab.GMT.read(gm)

    # TODO `@test`.
    BioLab.Dict.print(se_ge_; n = 2)

    @test length(se_ge_) == re

end

# ---- #

@test length(BioLab.GMT.read((gm1, gm2))) == le1 + le2
