using Test: @test

using Omics

# ---- #

@test size(Omics.Table.rea(Omics.Gene._HG)) === (43840, 54)

# ---- #

const D1 = Omics.Gene.map_hgnc(["hgnc_id"])

@test length(D1) === 43840

for (ke, re) in ()

    @test D1[ke] === re

end

# ---- #

@test size(Omics.Table.rea(Omics.Gene._EN)) === (591229, 10)

# ---- #

const D2 = Omics.Gene.map_ensembl()

@test length(D2) === 788360

for (ke, re) in
    (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test D2[ke] === re

end
