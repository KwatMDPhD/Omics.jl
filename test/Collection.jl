using Test: @test

using BioLab

# ---- #

an1_ = ('1', '2', 'K')

an_id = Dict('A' => 1, '2' => 2, '3' => 3, 'Q' => 4, 'K' => 5)

@test BioLab.Collection.is_in(an_id, an1_) ==
      BioLab.Collection.is_in(an_id, collect(an1_)) ==
      [false, true, false, false, true]

an_id = Dict('A' => 5, '2' => 4, '3' => 3, 'Q' => 2, 'K' => 1)

@test BioLab.Collection.is_in(an_id, an1_) ==
      BioLab.Collection.is_in(an_id, collect(an1_)) ==
      [true, false, false, true, false]

# ---- #

di = joinpath(BioLab.DA, "FeatureSetEnrichment")

fe_ = reverse!(BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))[!, 1])

fe1_ = BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

fe1s = Set(fe1_)

fe_id = Dict(fe => id for (id, fe) in enumerate(fe_))

# 443.657 ns (7 allocations: 1.13 KiB)
@btime Set($fe1_);

# 510.250 μs (7 allocations: 800.92 KiB)
@btime Dict(fe => id for (id, fe) in enumerate($fe_));

# 738.584 μs (2 allocations: 19.67 KiB)
@btime [fe in $fe1_ for fe in $fe_];

# 466.875 μs (2 allocations: 19.67 KiB)
@btime [fe in $fe1s for fe in $fe_];

# 740.458 μs (3 allocations: 6.84 KiB)
@btime in($fe1_).($fe_);

# 464.167 μs (3 allocations: 6.84 KiB)
@btime in($fe1s).($fe_);

# 384.698 ns (2 allocations: 2.66 KiB)
@btime BioLab.Collection.is_in($fe_id, $fe1_);
