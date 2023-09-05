using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "GMT")

# ---- #

@test BioLab.Path.read(DA) == ["c2.all.v7.1.symbols.gmt", "h.all.v7.1.symbols.gmt"]

# ---- #

for (gm, re) in (("h.all.v7.1.symbols.gmt", 50), ("c2.all.v7.1.symbols.gmt", 5529))

    gm = joinpath(DA, gm)

    @test length(BioLab.GMT.read(gm)) == re

    # 642.625 μs (1031 allocations: 1.91 MiB)
    # 46.110 ms (103655 allocations: 101.19 MiB)
    #@btime BioLab.GMT.read($gm)

end
