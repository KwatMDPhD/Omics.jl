using Test: @test

using BioLab

# ---- #

const GS = "GSE122404"

# ---- #

const GZ = BioLab.GEO.download(BioLab.TE, GS)

# ---- #

@test isfile(GZ)

# ---- #

const BL_TH = BioLab.GEO.read(GZ)

# ---- #

@test length(BL_TH["DATABASE"]) === 1

# ---- #

@test length(BL_TH["DATABASE"]["GeoMiame"]) === 4

# ---- #

@test length(BL_TH["SERIES"]) === 1

# ---- #

@test length(BL_TH["SERIES"]["GSE122404"]) === 44

# ---- #

@test length(BL_TH["PLATFORM"]) === 1

# ---- #

@test length(BL_TH["PLATFORM"]["GPL16686"]) === 47

# ---- #

@test length(BioLab.GEO._dice(BL_TH["PLATFORM"]["GPL16686"]["table"])) === 53982

# ---- #

@test length(BL_TH["SAMPLE"]) === 20

# ---- #

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 36

# ---- #

@test length(BioLab.GEO._dice(BL_TH["SAMPLE"]["GSM3466115"]["table"])) === 53618

# ---- #

# 426.919 ms (11344 allocations: 27.75 MiB)
@btime BioLab.GEO.read($GZ);

# ---- #

# 33.420 ms (107976 allocations: 16.79 MiB)
@btime BioLab.GEO._dice($(BL_TH["PLATFORM"]["GPL16686"]["table"]));

# ---- #

# 11.501 ms (107248 allocations: 16.70 MiB)
@btime BioLab.GEO._dice($(BL_TH["SAMPLE"]["GSM3466115"]["table"]));

# ---- #

const NA_FEATURE_X_SAMPLE_X_ANY = BioLab.GEO.tabulate(BL_TH)

# ---- #

@test length(NA_FEATURE_X_SAMPLE_X_ANY) === 2

# ---- #

const CHARACTERISTIC_X_SAMPLE_X_STRING = NA_FEATURE_X_SAMPLE_X_ANY["Characteristic"]

# ---- #

const FEATURE_X_SAMPLE_X_NUMBER = NA_FEATURE_X_SAMPLE_X_ANY["GPL16686"]

# ---- #

@test size(CHARACTERISTIC_X_SAMPLE_X_STRING) === (1, 21)

# ---- #

@test size(FEATURE_X_SAMPLE_X_NUMBER) === (53617, 21)

# ---- #

@test names(CHARACTERISTIC_X_SAMPLE_X_STRING)[2:end] == names(FEATURE_X_SAMPLE_X_NUMBER)[2:end]

# ---- #

# 571.793 ms (4576264 allocations: 552.70 MiB)
@btime BioLab.GEO.tabulate($BL_TH);

# ---- #

for (gs, re) in (
    ("GSE197763", Dict("Characteristic" => (4, 127))),
    ("GSE13534", Dict("Characteristic" => (0, 5), "GPL96" => (22283, 5))),
)

    na_feature_x_sample_x_any =
        BioLab.GEO.tabulate(BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, gs)))

    for (ke, si) in re

        @test size(na_feature_x_sample_x_any[ke]) === si

    end

end

# ---- #

BioLab.GEO.get
