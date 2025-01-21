using Omics

using Test: @test

# ---- #

const HG = Omics.Table.rea(Omics.Gene.HT)

@test size(HG) === (43840, 54)

# ---- #

const EN = Omics.Table.rea(Omics.Gene.ET)

@test size(EN) === (591229, 10)

# ---- #

const UN = Omics.Table.rea(Omics.Gene.UT)

@test size(UN) === (20398, 7)

@test allunique(UN[!, 2])

# ---- #

const HK_ = ["hgnc_id"]

const HG_GE = Omics.Gene.ma(HG, HK_, Omics.Gene.HV)

@test length(HG_GE) === 43840

for (ke, re) in ()

    @test HG_GE[ke] === re

end

# 19.180 ms (742290 allocations: 32.79 MiB)
#@btime Omics.Gene.ma(HG, HK_, Omics.Gene.HV);

# ---- #

const EN_GE = Omics.Gene.ma(EN, Omics.Gene.EK_, Omics.Gene.EV)

@test length(EN_GE) === 788360

for (ke, re) in
    (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_GE[ke] === re

end

# 1.931 s (38278731 allocations: 1.60 GiB)
#@btime Omics.Gene.ma(EN, Omics.Gene.EK_, Omics.Gene.EV);

# ---- #

const UN_IR = Omics.Gene.map_uniprot(UN)

@test length(UN_IR) === 20398

for (ir, ke, re) in (("CD8A", "Gene Names", ["CD8A", "MAL"]),)

    @test UN_IR[ir][ke] == re

end

# 21.909 ms (315019 allocations: 32.09 MiB)
#@btime Omics.Gene.map_uniprot(UN);
