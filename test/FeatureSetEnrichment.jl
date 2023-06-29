include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "FeatureSetEnrichment")

@test readdir(DA) == []

# ---- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

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

for (ex, re) in ((1.0, (6, 5.0, 2.0)), (2.0, (6, 9.0, 2.0)))

    @test BioLab.FeatureSetEnrichment._sum_10(sc_, bo_, ex) == re

    # 6.417 ns (0 allocations: 0 bytes)
    # 19.121 ns (0 allocations: 0 bytes)    
    @btime BioLab.FeatureSetEnrichment._sum_10($sc_, $bo_, $ex)

end

# ---- #

for (ex, re) in ((1.0, (6.0, 5.0)), (2.0, (10.0, 9.0)))

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

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_card("AK")

for al in (BioLab.FeatureSetEnrichment.KS(), BioLab.FeatureSetEnrichment.KLioM())

    BioLab.FeatureSetEnrichment.enrich(al, fe_, sc_, fe1_; title_text = string(al))

end

# ---- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

# ---- #

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    BioLab.FeatureSetEnrichment._enrich(
        al,
        fe_,
        sc_,
        bo_;
        title_text = BioLab.String.split_get(string(al), '.', 3)[1:(end - 2)],
        lo = "Low Phenotype",
        hi = "High Phenotype",
    )

end

# ---- #

feature_x_sample_x_score = DataFrame(
    "Feature" => fe_,
    "Score" => sc_,
    "Score x 10" => sc_ * 10.0,
    "Constant" => fill(0.8, length(fe_)),
)

se_fe1_ =
    BioLab.GMT.read(joinpath(@__DIR__, "FeatureSetEnrichment.data", "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

# ---- #

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    # 45.583 μs (0 allocations: 0 bytes)
    # 220.875 μs (0 allocations: 0 bytes)
    # 364.458 μs (0 allocations: 0 bytes)
    # @btime BioLab.FeatureSetEnrichment._enrich($al, $fe_, $sc_, $bo_; pl = $false);

    # 570.000 μs (9 allocations: 20.80 KiB)
    # 745.625 μs (9 allocations: 20.80 KiB)
    # 891.041 μs (9 allocations: 20.80 KiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1_; pl = $false);

    # 3.240 ms (108 allocations: 1.49 MiB)
    # 12.069 ms (108 allocations: 1.49 MiB)
    # 19.324 ms (108 allocations: 1.49 MiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1___);

    # 11.463 ms (463 allocations: 8.66 MiB)
    # 37.931 ms (463 allocations: 8.66 MiB)
    # 59.793 ms (463 allocations: 8.66 MiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $feature_x_sample_x_score, $se_, $fe1___);

end
