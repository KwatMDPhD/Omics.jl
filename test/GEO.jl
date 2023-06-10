using Logging

include("environment.jl")

# ---- #

gs = "GSE122404"

# ---- #

ty_bl = BioLab.GEO.read(gs)

# ---- #

@test length(ty_bl["DATABASE"]) == 1

@test length(ty_bl["DATABASE"]["GeoMiame"]) == 4

# ---- #

@test length(ty_bl["SERIES"]) == 1

@test length(ty_bl["SERIES"]["GSE122404"]) == 44

# ---- #

@test length(ty_bl["SAMPLE"]) == 20

@test length(ty_bl["SAMPLE"]["GSM3466115"]) == 36

@test size(BioLab.DataFrame.make(ty_bl["SAMPLE"]["GSM3466115"]["table"])) == (53617, 2)

# ---- #

pl_ke_va = ty_bl["PLATFORM"]

@test length(pl_ke_va) == 1

pl = "GPL16686"

@test length(pl_ke_va[pl]) == 47

platform_table = pl_ke_va[pl]["table"]

@test size(BioLab.DataFrame.make(platform_table)) == (53981, 8)

# ---- #

disable_logging(Warn)
# 634.461 ms (3441093 allocations: 208.35 MiB)
@btime BioLab.GEO.read($gs);
disable_logging(Debug)

# ---- #

feature_x_information_x_anything = BioLab.DataFrame.make(platform_table)

@test BioLab.GEO._name(pl, feature_x_information_x_anything)["16657485"] == "XR_132471"

# ---- #

disable_logging(Warn)
# 9.623 ms (430770 allocations: 18.68 MiB)
@btime BioLab.GEO._name($pl, $feature_x_information_x_anything);
disable_logging(Debug)

# ---- #

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(ty_bl)

@test size(characteristic_x_sample_x_string) == (1, 21)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (53617, 21)

@test names(characteristic_x_sample_x_string)[2:end] == names(feature_x_sample_x_float[1])[2:end]

# ---- #

disable_logging(Warn)
# 725.120 ms (3812073 allocations: 680.33 MiB)
@btime BioLab.GEO.tabulate($ty_bl);
disable_logging(Debug)

# ---- #

ty_bl = BioLab.GEO.read("GSE112")

@test length(ty_bl["PLATFORM"]) == 2

@test @is_error BioLab.GEO.tabulate(ty_bl)

# ---- #

ty_bl = BioLab.GEO.read("GSE197763")

@test length(ty_bl["PLATFORM"]) == 2

@test all(!haskey(ke_va, "table") for ke_va in values(ty_bl["PLATFORM"]))

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(ty_bl)

@test size(characteristic_x_sample_x_string) == (4, 127)

@test length(feature_x_sample_x_float) == 0

# ---- #

ty_bl = BioLab.GEO.read("GSE13534")

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(ty_bl)

@test isempty(characteristic_x_sample_x_string)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (22283, 5)
