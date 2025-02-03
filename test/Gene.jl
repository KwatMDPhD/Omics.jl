using Test: @test

using Omics

# ---- #

const TH = Omics.Table.rea(Omics.Gene.TH)

@test size(TH) === (43840, 54)

# ---- #

const TE = Omics.Table.rea(Omics.Gene.TE)

@test size(TE) === (591229, 10)

# ---- #

const TU = Omics.Table.rea(Omics.Gene.TU)

@test size(TU) === (20398, 7)

@test allunique(TU[!, 2])

# ---- #

# 237.210 ms (2243074 allocations: 188.60 MiB)

const KE_ = ["hgnc_id"]

const K1_V1 = Omics.Gene.map_hgnc(KE_)

@test length(K1_V1) === 43840

for (ke, re) in ()

    @test K1_V1[ke] === re

end

#@btime Omics.Gene.map_hgnc(KE_);

# ---- #

# 2.648 s (38724914 allocations: 2.54 GiB)

const K2_V2 = Omics.Gene.map_ensembl()

@test length(K2_V2) === 788360

for (ke, re) in
    (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test K2_V2[ke] === re

end

#@btime Omics.Gene.map_ensembl();

# ---- #

# 119.177 ms (443387 allocations: 65.41 MiB)

const K3_V3 = Omics.Gene.map_uniprot()

@test length(K3_V3) === 20398

for (pr, ke, re) in (("CD8A", "Gene Names", ["CD8A", "MAL"]),)

    @test K3_V3[pr][ke] == re

end

#@btime Omics.Gene.map_uniprot();
