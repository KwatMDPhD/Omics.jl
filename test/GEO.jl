using Logging

include("environment.jl")

# ---- #

gs = "GSE122404"

# ---- #

ty_bl = BioLab.GEO.read(gs)

@test length(ty_bl["DATABASE"]) == 1

@test length(ty_bl["DATABASE"]["GeoMiame"]) == 4

@test length(ty_bl["SERIES"]) == 1

@test length(ty_bl["SERIES"]["GSE122404"]) == 44

@test length(ty_bl["SAMPLE"]) == 20

@test length(ty_bl["SAMPLE"]["GSM3466115"]) == 36

@test size(BioLab.DataFrame.make(ty_bl["SAMPLE"]["GSM3466115"]["table"])) == (53617, 2)

@test length(ty_bl["PLATFORM"]) == 1

@test length(ty_bl["PLATFORM"]["GPL16686"]) == 47

@test size(BioLab.DataFrame.make(ty_bl["PLATFORM"]["GPL16686"]["table"])) == (53981, 8)

# ---- #

disable_logging(Warn)
# 634.461 ms (3441093 allocations: 208.35 MiB)
@btime BioLab.GEO.read($gs);
disable_logging(Debug)

# ---- #

pl_ke_va = ty_bl["PLATFORM"]

pl = collect(keys(pl_ke_va))[1]

feature_x_information_x_anything = BioLab.DataFrame.make(pl_ke_va[pl]["table"])

fe_na = BioLab.GEO._name(pl, feature_x_information_x_anything)

@test fe_na["16657485"] == "XR_132471"

# ---- #

disable_logging(Warn)
# 9.623 ms (430770 allocations: 18.68 MiB)
@btime fe_na = BioLab.GEO._name($pl, $feature_x_information_x_anything);
disable_logging(Debug)

# ---- #

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(ty_bl)

@test size(characteristic_x_sample_x_string) == (1, 21)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (53617, 21)

@test names(characteristic_x_sample_x_string)[2:end] == names(feature_x_sample_x_float[1])[2:end]

# ---- #

disable_logging(Warn)
# 803.771 ms (3812200 allocations: 716.46 MiB)
@btime BioLab.GEO.tabulate($ty_bl);
disable_logging(Debug)

# ---- #

disable_logging(Warn)
for gs in ("GSE13534", "GSE107011", "GSE168204", "GSE141484")

    println(gs)

    da_ = BioLab.GEO.tabulate(BioLab.GEO.read(gs))

    allequal(size(da, 2) for da in da_)

    for da in da_

        display(first(da, 2))

    end

    println()

end
disable_logging(Debug)
