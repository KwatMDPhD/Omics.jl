using Test: @test

using BioLab

# ---- #

const GS = "GSE122404"

@test BioLab.Error.@is_error BioLab.GEO.download("", GS)

const GZ = BioLab.GEO.download(BioLab.TE, GS)

@test isfile(GZ)

# ---- #

const BL_TH = BioLab.GEO.read(GZ)

# ---- #

@test length(BL_TH["DATABASE"]) == 1

@test length(BL_TH["DATABASE"]["GeoMiame"]) == 4

@test length(BL_TH["SERIES"]) == 1

@test length(BL_TH["SERIES"]["GSE122404"]) == 44

@test length(BL_TH["PLATFORM"]) == 1

@test length(BL_TH["PLATFORM"]["GPL16686"]) == 47

@test length(BioLab.String.dice(BL_TH["PLATFORM"]["GPL16686"]["table"])) == 53982

@test length(BL_TH["SAMPLE"]) == 20

@test length(BL_TH["SAMPLE"]["GSM3466115"]) == 36

@test length(BioLab.String.dice(BL_TH["SAMPLE"]["GSM3466115"]["table"])) == 53618

# 623.414 ms (3439384 allocations: 208.13 MiB)
@btime BioLab.GEO.read($GZ);

# ---- #

const CHARACTERISTIC_X_SAMPLE_X_STRING, PL_DA = BioLab.GEO.tabulate(BL_TH)

@test size(CHARACTERISTIC_X_SAMPLE_X_STRING) == (1, 21)

@test length(PL_DA) == 1

FEATURE_X_SAMPLE_X_NUMBER = PL_DA[collect(keys(PL_DA))[1]]

@test size(FEATURE_X_SAMPLE_X_NUMBER) == (53617, 21)

@test names(CHARACTERISTIC_X_SAMPLE_X_STRING)[2:end] == names(FEATURE_X_SAMPLE_X_NUMBER)[2:end]

# 655.075 ms (4702093 allocations: 585.20 MiB)
#@btime BioLab.GEO.tabulate($BL_TH);

# ---- #

for (gs, re_) in (("GSE197763", ((4, 127), (0, 0))), ("GSE13534", ((0, 0), (22283, 5))))

    ch_x_sa_x_st, pl_da = BioLab.GEO.tabulate(BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, gs)))

    @test size(ch_x_sa_x_st) == re_[1]

    for ((pl, fe_x_sa_x_nu), re) in zip(pl_da, re_[2:end])

        @test size(fe_x_sa_x_nu) == re

    end

end
