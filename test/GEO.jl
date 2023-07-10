using DataFrames: DataFrame

using Logging: Debug, Warn, disable_logging

using Test: @test

using BioLab

# ---- #

const NAR = "Row Name"

const CO_ = ["Column 1", "Column 2", "Column 3"]

for (ro_an__, re) in (
    (
        (
            Dict("Row 1" => 1, "Row 2" => 2),
            Dict("Row 2" => 2, "Row 3" => 3),
            Dict("Row 1" => 1, "Row 2" => 2, "Row 3" => 3),
        ),
        DataFrame(
            NAR => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => [1, 2, missing],
            "Column 2" => [missing, 2, 3],
            "Column 3" => [1, 2, 3],
        ),
    ),
    (
        (
            Dict("Row 1" => 'a', "Row 2" => 'b'),
            Dict("Row 2" => 'b', "Row 3" => 'c'),
            Dict("Row 1" => 'a', "Row 2" => 'b', "Row 3" => 'c'),
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => ['a', 'b', missing],
            "Column 2" => [missing, 'b', 'c'],
            "Column 3" => ['a', 'b', 'c'],
        ),
    ),
)

    @test isequal(BioLab.GEO._make(NAR, CO_, ro_an__), re)

    # 2.338 μs (43 allocations: 3.41 KiB)
    # 2.296 μs (43 allocations: 3.38 KiB)
    @btime BioLab.GEO._make($NAR, $CO_, $ro_an__)

end

# ---- #

gs = "GSE122404"

# ---- #

gz = BioLab.GEO.download(BioLab.TE, gs)

@test isfile(gz)

# ---- #

bl_th = BioLab.GEO.read(gz)

@test length(bl_th["DATABASE"]) == 1

@test length(bl_th["DATABASE"]["GeoMiame"]) == 4

@test length(bl_th["SERIES"]) == 1

@test length(bl_th["SERIES"]["GSE122404"]) == 44

@test length(bl_th["SAMPLE"]) == 20

@test length(bl_th["SAMPLE"]["GSM3466115"]) == 36

@test size(BioLab.GEO._make(bl_th["SAMPLE"]["GSM3466115"]["table"])) == (53617, 2)

pl_ke_va = bl_th["PLATFORM"]

@test length(pl_ke_va) == 1

pl = "GPL16686"

@test length(pl_ke_va[pl]) == 47

tas = pl_ke_va[pl]["table"]

@test size(BioLab.GEO._make(tas)) == (53981, 8)

# ---- #

disable_logging(Warn)

# 646.881 ms (3441018 allocations: 208.35 MiB)
@btime BioLab.GEO.read($gz);

disable_logging(Debug)

# ---- #

ta = BioLab.GEO._make(tas)

@test BioLab.GEO._map_feature(pl, ta)["16657485"] == "XR_132471"

# ---- #

disable_logging(Warn)

# 15.094 ms (430769 allocations: 18.68 MiB)
@btime BioLab.GEO._map_feature($pl, $ta);

disable_logging(Debug)

# ---- #

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(bl_th)

@test size(characteristic_x_sample_x_string) == (1, 21)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (53617, 21)

@test names(characteristic_x_sample_x_string)[2:end] == names(feature_x_sample_x_float[1])[2:end]

# ---- #

disable_logging(Warn)

# 932.823 ms (12535717 allocations: 1002.24 MiB)
@btime BioLab.GEO.tabulate($bl_th);

disable_logging(Debug)

# ---- #

bl_th = BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, "GSE112"))

@test length(bl_th["PLATFORM"]) == 2

@test BioLab.@is_error BioLab.GEO.tabulate(bl_th)

# ---- #

bl_th = BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, "GSE197763"))

@test length(bl_th["PLATFORM"]) == 2

@test all(!haskey(ke_va, "table") for ke_va in values(bl_th["PLATFORM"]))

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(bl_th)

@test size(characteristic_x_sample_x_string) == (4, 127)

@test length(feature_x_sample_x_float) == 0

# ---- #

bl_th = BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, "GSE13534"))

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(bl_th)

@test isnothing(characteristic_x_sample_x_string)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (22283, 5)
