using Test: @test

using BioLab

# ---- #

const GS = "GSE122404"

@test BioLab.Error.@is BioLab.GEO.download("", GS)

# ---- #

const GZ = BioLab.GEO.download(BioLab.TE, GS)

@test isfile(GZ)

# ---- #

const BL_TH = BioLab.GEO.read(GZ)

# ---- #

@test length(BL_TH["DATABASE"]) === 1

@test length(BL_TH["DATABASE"]["GeoMiame"]) === 4

# ---- #

@test length(BL_TH["SERIES"]) === 1

@test length(BL_TH["SERIES"]["GSE122404"]) === 44

# ---- #

@test length(BL_TH["PLATFORM"]) === 1

@test length(BL_TH["PLATFORM"]["GPL16686"]) === 47

@test length(BioLab.String.dice(BL_TH["PLATFORM"]["GPL16686"]["table"])) === 53982

# ---- #

@test length(BL_TH["SAMPLE"]) === 20

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 36

@test length(BioLab.String.dice(BL_TH["SAMPLE"]["GSM3466115"]["table"])) === 53618

# ---- #

# 626.465 ms (3439280 allocations: 224.78 MiB)
#@btime BioLab.GEO.read($GZ);

# ---- #

const CHARACTERISTIC_X_SAMPLE_X_STRING, PL_FEATURE_X_SAMPLE_X_NUMBER = BioLab.GEO.tabulate(BL_TH)

# ---- #

@test size(CHARACTERISTIC_X_SAMPLE_X_STRING) === (1, 21)

# ---- #

@test length(PL_FEATURE_X_SAMPLE_X_NUMBER) === 1

const FEATURE_X_SAMPLE_X_NUMBER = PL_FEATURE_X_SAMPLE_X_NUMBER["GPL16686"]

@test size(FEATURE_X_SAMPLE_X_NUMBER) === (53617, 21)

# ---- #

@test names(CHARACTERISTIC_X_SAMPLE_X_STRING)[2:end] == names(FEATURE_X_SAMPLE_X_NUMBER)[2:end]

# ---- #

# 588.533 ms (4577223 allocations: 552.76 MiB)
#@btime BioLab.GEO.tabulate($BL_TH);

# ---- #

for (gs, re_) in (("GSE197763", ((4, 127),)), ("GSE13534", ((0, 5), (22283, 5))))

    characteristic_x_sample_x_any, pl_feature_x_sample_x_number =
        BioLab.GEO.tabulate(BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, gs)))

    @test 1 + length(pl_feature_x_sample_x_number) === length(re_)

    @test size(characteristic_x_sample_x_any) === re_[1]

    for (feature_x_sample_x_number, re) in zip(values(pl_feature_x_sample_x_number), re_[2:end])

        @test size(feature_x_sample_x_number) === re

    end

end
