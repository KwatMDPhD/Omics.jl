include("environment.jl")

using DataFrames

# ---- #

DA = joinpath(BioLab.DA, "FeatureSetEnrichment")

@test readdir(DA) == ["c2.all.v7.1.symbols.gmt", "gene_x_statistic_x_number.tsv"]

# ---- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

n = length(sc_)

# ---- #

id = 1

for (ex, re) in ((-1.0, 0.5), (1.0, 2.0), (2.0, 4.0), (3.0, 8.0))

    @test BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex) == re

    # 6.041 ns (0 allocations: 0 bytes)
    # 1.875 ns (0 allocations: 0 bytes)
    # 5.708 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._get_absolute_raise($sc_, $id, $ex)

end

# ---- #

bo_ = [true, true, false, true, false, true]

for (ex, re) in ((1.0, (n, 5.0, 2.0)), (2.0, (n, 9.0, 2.0)))

    @test BioLab.FeatureSetEnrichment._sum_10(sc_, bo_, ex) == re

    # 6.417 ns (0 allocations: 0 bytes)
    # 19.121 ns (0 allocations: 0 bytes)    
    @btime BioLab.FeatureSetEnrichment._sum_10($sc_, $bo_, $ex)

end

# ---- #

for (ex, re) in ((1.0, (n, 6.0, 5.0)), (2.0, (n, 10.0, 9.0)))

    @test BioLab.FeatureSetEnrichment._sum_all1(sc_, bo_, ex) == re

    # 7.708 ns (0 allocations: 0 bytes)
    # 28.839 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._sum_all1($sc_, $bo_, $ex)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(TE, "plot_mountain.html"),
    ["Black Beard", "Law"],
    [2.0, -2],
    [true, true],
    [0.1, -0.1],
    11.29,
)

# ---- #

function test_type_trend(fe_, sc_, fe1_)

    @test fe_ isa Vector{<:AbstractString}

    @test sc_ isa Vector{Float64}

    @test all(<=(0), diff(sc_))

    @test fe1_ isa Vector{String}

end

# ---- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_card("A2K")

test_type_trend(fe_, sc_, fe1_)

@test length(fe_) == 13

@test length(fe1_) == 3

# ---- #

for (n, n1) in ((3, 2), (4, 2), (5, 3))

    fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_random(n, n1)

    test_type_trend(fe_, sc_, fe1_)

    @test length(fe_) == n

    @test length(fe1_) == n1

end

# ---- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

test_type_trend(fe_, sc_, fe1_)

@test length(fe_) == 20046

@test length(fe1_) == 24

# ---- #

function _string(al)

    BioLab.String.split_get(string(al), '.', 3)[1:(end - 2)]

end

# ---- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_card("AK")

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
    BioLab.FeatureSetEnrichment.KLioP(),
)

    BioLab.FeatureSetEnrichment.enrich(al, fe_, sc_, fe1_; title_text = _string(al))

end

# ---- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

# ---- #

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
    BioLab.FeatureSetEnrichment.KLioP(),
)

    BioLab.FeatureSetEnrichment._enrich(al, fe_, sc_, bo_; title_text = _string(al))

end

# ---- #

sa_ = ["Score", "Score x 10", "Constant"]

fe_x_sa_x_sc = hcat(sc_, sc_ * 10.0, fill(0.8, length(fe_)))

se_fe1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

# ---- #

for al in (
    # 18.681 ns (0 allocations: 0 bytes)
    # 277.269 ns (5 allocations: 448 bytes)
    # 168.416 μs (58 allocations: 5.53 KiB)
    # 497.500 μs (209 allocations: 21.95 KiB)
    BioLab.FeatureSetEnrichment.KS(),
    # 15.865 ns (0 allocations: 0 bytes)
    # 274.620 ns (5 allocations: 448 bytes)
    # 165.208 μs (58 allocations: 5.53 KiB)
    # 498.000 μs (209 allocations: 21.95 KiB)
    BioLab.FeatureSetEnrichment.KSa(),
    # 97.956 ns (0 allocations: 0 bytes)
    # 406.250 ns (5 allocations: 448 bytes)
    # 169.167 μs (58 allocations: 5.53 KiB)
    # 502.750 μs (209 allocations: 21.95 KiB)
    BioLab.FeatureSetEnrichment.KLi(),
    # 367.421 ns (0 allocations: 0 bytes)
    # 664.430 ns (5 allocations: 448 bytes)
    # 179.958 μs (58 allocations: 5.53 KiB)
    # 549.416 μs (209 allocations: 21.95 KiB)
    BioLab.FeatureSetEnrichment.KLioM(),
    # 367.150 ns (0 allocations: 0 bytes)
    # 690.190 ns (5 allocations: 448 bytes)
    # 177.916 μs (58 allocations: 5.53 KiB)
    # 542.084 μs (209 allocations: 21.95 KiB)
    BioLab.FeatureSetEnrichment.KLioP(),
)

    @btime BioLab.FeatureSetEnrichment._enrich($al, $fe_, $sc_, $bo_; pl = $false)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1_; pl = $false)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1___)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sa_, $fe_x_sa_x_sc, $se_, $fe1___)

end
