using Test: @test

using BioLab

# ---- #

const AN1_ = ('A', 'B')

for (an_id, re) in (
    (Dict(), ()),
    (Dict('A' => 1), (true,)),
    (Dict('B' => 1), (true,)),
    (Dict('Z' => 1), (false,)),
    (Dict('A' => 1, 'B' => 2, 'Z' => 3), (true, true, false)),
    (Dict('A' => 1, 'Z' => 2, 'B' => 3), (true, false, true)),
)

    bi_ = BitVector(re)

    bo_ = convert(Vector{Bool}, bi_)

    @test BioLab.Collection.is_in(an_id, AN1_) == bi_ == bo_

end

# ---- #

const DA = joinpath(BioLab._DA, "FeatureSetEnrichment")

const FE_ =
    reverse!(BioLab.Table.read(joinpath(DA, "gene_x_statistic_x_number.tsv"); select = [1])[!, 1])

const FE1_ = BioLab.GMT.read(joinpath(DA, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 737.667 μs (2 allocations: 19.67 KiB)
#@btime [fe in $FE1_ for fe in $FE_];

# 739.250 μs (3 allocations: 6.84 KiB)
#@btime in($FE1_).($FE_);

# ---- #

const FE1S = Set(FE1_)

# 440.864 ns (7 allocations: 1.13 KiB)
#@btime Set($FE1_);

# 459.542 μs (2 allocations: 19.67 KiB)
#@btime [fe in $FE1S for fe in $FE_];

# 464.167 μs (3 allocations: 6.84 KiB)
#@btime in($FE1S).($FE_);

# ---- #

const FE_ID = Dict(fe => id for (id, fe) in enumerate(FE_))

# 508.250 μs (7 allocations: 800.92 KiB)
#@btime Dict(fe => id for (id, fe) in enumerate($FE_));

# 384.698 ns (2 allocations: 2.66 KiB)
#@btime BioLab.Collection.is_in($FE_ID, $FE1_);
