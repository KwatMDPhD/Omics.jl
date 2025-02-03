using Test: @test

using Omics

# ---- #

const HT = Omics.Table.rea(Omics.Gene.HT)

@test size(HT) === (43840, 54)

# ---- #

const ET = Omics.Table.rea(Omics.Gene.ET)

@test size(ET) === (591229, 10)

# ---- #

const UT = Omics.Table.rea(Omics.Gene.UT)

@test size(UT) === (20398, 7)

@test allunique(UT[!, 2])

# ---- #

# 237.210 ms (2243074 allocations: 188.60 MiB)

const HK_ = ["hgnc_id"]

const HK_HV = Omics.Gene.map_hgnc(HK_)

@test length(HK_HV) === 43840

for (ke, re) in ()

    @test HK_HV[ke] === re

end

#@btime Omics.Gene.map_hgnc(HK_);

# ---- #

# 2.683 s (38724914 allocations: 2.54 GiB)

const EK_EV = Omics.Gene.map_ensembl()

@test length(EK_EV) === 788360

for (ke, re) in
    (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EK_EV[ke] === re

end

#@btime Omics.Gene.map_ensembl();

# ---- #

# 119.177 ms (443387 allocations: 65.41 MiB)

const UK_UV = Omics.Gene.map_uniprot()

@test length(UK_UV) === 20398

for (pr, ke, re) in (("CD8A", "Gene Names", ["CD8A", "MAL"]),)

    @test UK_UV[pr][ke] == re

end

#@btime Omics.Gene.map_uniprot();
