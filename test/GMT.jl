using Test: @test

# ---- #

DA = joinpath(BioLab.DA, "GMT")

# ---- #

@test readdir(DA) == ["c2.all.v7.1.symbols.gmt", "h.all.v7.1.symbols.gmt"]

# ---- #

for (na, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    gm = joinpath(DA, na)

    @test length(BioLab.GMT.read(gm)) == re

    # 340.875 μs (7767 allocations: 977.20 KiB)
    # 26.456 ms (521432 allocations: 51.53 MiB)
    #@btime BioLab.GMT.read($gm)

end
