using Test: @test

using BioLab

# ---- #

const AN1_ = ('1', '2', 'K')

const AN_ID1 = Dict('A' => 1, '2' => 2, '3' => 3, 'Q' => 4, 'K' => 5)

@test BioLab.Collection.is_in(AN_ID1, AN1_) ==
      BioLab.Collection.is_in(AN_ID1, collect(AN1_)) ==
      [false, true, false, false, true]

const AN_ID2 = Dict('A' => 5, '2' => 4, '3' => 3, 'Q' => 2, 'K' => 1)

@test BioLab.Collection.is_in(AN_ID2, AN1_) ==
      BioLab.Collection.is_in(AN_ID2, collect(AN1_)) ==
      [true, false, false, true, false]

# ---- #

const DI = joinpath(BioLab.DA, "FeatureSetEnrichment")

const FE_ = reverse!(BioLab.Table.read(joinpath(DI, "gene_x_statistic_x_number.tsv"))[!, 1])

const FE1_ = BioLab.GMT.read(joinpath(DI, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

const FE1S = Set(FE1_)

const FE_ID = Dict(fe => id for (id, fe) in enumerate(FE_))

# 443.657 ns (7 allocations: 1.13 KiB)
@btime Set($FE1_);

# 510.250 μs (7 allocations: 800.92 KiB)
@btime Dict(fe => id for (id, fe) in enumerate($FE_));

# 738.584 μs (2 allocations: 19.67 KiB)
@btime [fe in $FE1_ for fe in $FE_];

# 466.875 μs (2 allocations: 19.67 KiB)
@btime [fe in $FE1S for fe in $FE_];

# 740.458 μs (3 allocations: 6.84 KiB)
@btime in($FE1_).($FE_);

# 464.167 μs (3 allocations: 6.84 KiB)
@btime in($FE1S).($FE_);

# 384.698 ns (2 allocations: 2.66 KiB)
@btime BioLab.Collection.is_in($FE_ID, $FE1_);
