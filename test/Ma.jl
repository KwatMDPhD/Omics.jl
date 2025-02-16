using Random: randstring

using Test: @test

using Omics

# ---- #

@test length(Omics.Ma.make(Omics.Table.rea(Omics.Gene._HG), ["hgnc_id"], "symbol")) ===
      43840

# ---- #

const DI = Dict(ch^2 => uppercase(ch^2) for ch in 'a':'z')

# ---- #

# 26.564 ns (0 allocations: 0 bytes)
# 26.564 ns (0 allocations: 0 bytes)
# 19.163 ns (1 allocation: 24 bytes)

for (ke, re) in (("aa", "AA"), ("zz", "ZZ"), ("??", "_??"))

    @test Omics.Ma.ge(DI, ke) === re

    #@btime Omics.Ma.ge(DI, $ke)

end

# ---- #

Omics.Ma.lo(map(ke -> Omics.Ma.ge(DI, ke), map(_ -> randstring('a':'b', 2), 1:1000)))
