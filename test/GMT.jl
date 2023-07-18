using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "GMT")

# ---- #

@test readdir(DA) == ["c2.all.v7.1.symbols.gmt", "h.all.v7.1.symbols.gmt"]

# ---- #

for (gm, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    gm = joinpath(DA, gm)

    @test length(BioLab.GMT.read(gm)) == re

    # 334.208 μs (7767 allocations: 977.20 KiB)
    # 25.456 ms (521432 allocations: 51.53 MiB)
    @btime BioLab.GMT.read($gm)

end
