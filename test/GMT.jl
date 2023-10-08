using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "GMT")

# ---- #

@test BioLab.Path.read(DA) == ["c2.all.v7.1.symbols.gmt", "h.all.v7.1.symbols.gmt"]

# ---- #

for (gm, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    gm = joinpath(DA, gm)

    @test length(BioLab.GMT.read(gm)) === re

    # 349.667 μs (7767 allocations: 1.13 MiB)
    # 28.330 ms (521516 allocations: 62.80 MiB)
    @btime BioLab.GMT.read($gm)

end
