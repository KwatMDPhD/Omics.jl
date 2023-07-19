using DataFrames: DataFrame

using Logging: Debug, Warn, disable_logging

using Test: @test

using BioLab

# ---- #

const GS = "GSE122404"

const GZ = BioLab.GEO.download(BioLab.TE, GS)

@test isfile(GZ)

# ---- #

const BL_TH = BioLab.GEO.read(GZ)

@test length(BL_TH["DATABASE"]) == 1

@test length(BL_TH["DATABASE"]["GeoMiame"]) == 4

@test length(BL_TH["SERIES"]) == 1

@test length(BL_TH["SERIES"]["GSE122404"]) == 44

@test length(BL_TH["PLATFORM"]) == 1

@test length(BL_TH["PLATFORM"]["GPL16686"]) == 47

@test length(BioLab.GEO._dice(BL_TH["PLATFORM"]["GPL16686"]["table"])) == 53982

@test length(BL_TH["SAMPLE"]) == 20

@test length(BL_TH["SAMPLE"]["GSM3466115"]) == 36

@test length(BioLab.GEO._dice(BL_TH["SAMPLE"]["GSM3466115"]["table"])) == 53618

disable_logging(Warn)

# 623.414 ms (3439384 allocations: 208.13 MiB)
@btime BioLab.GEO.read($GZ);

disable_logging(Debug)

# ---- #

characteristic_x_sample_x_string, feature_x_sample_x_float... = BioLab.GEO.tabulate(BL_TH)

@test size(characteristic_x_sample_x_string) == (1, 21)

@test length(feature_x_sample_x_float) == 1

@test size(feature_x_sample_x_float[1]) == (53617, 21)

@test names(characteristic_x_sample_x_string)[2:end] == names(feature_x_sample_x_float[1])[2:end]

disable_logging(Warn)

# 655.075 ms (4702093 allocations: 585.20 MiB)
@btime BioLab.GEO.tabulate($BL_TH);

disable_logging(Debug)

# ---- #

for (gs, si_) in (("GSE197763", ((4, 127), nothing)), ("GSE13534", (nothing, (22283, 5))))

    for (da, si) in
        zip(BioLab.GEO.tabulate(BioLab.GEO.read(BioLab.GEO.download(BioLab.TE, gs))), si_)

        if isnothing(si)

            @test isnothing(da)

        else

            @test size(da) == si

        end

    end

end
