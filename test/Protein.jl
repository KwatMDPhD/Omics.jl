using Test: @test

using Omics

# ---- #

const UN = Omics.Table.rea(Omics.Protein._UN)

@test size(UN) === (20398, 7)

@test allunique(UN[!, 2])

# ---- #

# 110.413 ms (413012 allocations: 50.57 MiB)

const DI = Omics.Protein.map_uniprot()

@test length(DI) === 20398

for (pr, ke, re) in (("CD8A", "Gene Names", "CD8A MAL"), ("CD8A", "Interacts with", ""))

    @test DI[pr][ke] == re

end

#@btime Omics.Protein.map_uniprot();
