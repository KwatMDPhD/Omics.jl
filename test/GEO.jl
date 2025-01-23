using Test: @test

using Omics

# ---- #

const SO = Omics.GEO.make_soft("GSE122404")

@test SO === "GSE122404_family.soft.gz"

# ---- #

const DA = joinpath(pkgdir(Omics), "data", "GEO")

const GZ = joinpath(DA, SO)

const BL_TH = Omics.GEO.rea(GZ)

const PL = "GPL16686"

@test collect(keys(BL_TH["PLATFORM"])) == [PL]

@test length(BL_TH["PLATFORM"][PL]) === 48

@test parse(Int, BL_TH["PLATFORM"][PL]["!Platform_data_row_count"]) ===
      lastindex(collect(Omics.GEO._each(BL_TH["PLATFORM"][PL]["_bo"]))) ===
      53981

@test collect(keys(BL_TH["SAMPLE"])) == [
    "GSM3466115"
    "GSM3466116"
    "GSM3466117"
    "GSM3466118"
    "GSM3466119"
    "GSM3466120"
    "GSM3466121"
    "GSM3466122"
    "GSM3466123"
    "GSM3466124"
    "GSM3466125"
    "GSM3466126"
    "GSM3466127"
    "GSM3466128"
    "GSM3466129"
    "GSM3466130"
    "GSM3466131"
    "GSM3466132"
    "GSM3466133"
    "GSM3466134"
]

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 37

# 369.377 ms (10622 allocations: 54.01 MiB)
#@btime Omics.GEO.rea(GZ);

# ---- #

@test Omics.GEO.get_sample(BL_TH) == [
    "GSM3466115 D458_Sensitive_DMSO_1"
    "GSM3466116 D458_Sensitive_DMSO_2"
    "GSM3466117 D458_Sensitive_DMSO_3"
    "GSM3466118 D458_Sensitive_DMSO_4"
    "GSM3466119 D458_Sensitive_DMSO_5"
    "GSM3466120 D458_Sensitive_JQ1_1"
    "GSM3466121 D458_Sensitive_JQ1_2"
    "GSM3466122 D458_Sensitive_JQ1_3"
    "GSM3466123 D458_Sensitive_JQ1_4"
    "GSM3466124 D458_Sensitive_JQ1_5"
    "GSM3466125 D458_Resistant_DMSO_1"
    "GSM3466126 D458_Resistant_DMSO_2"
    "GSM3466127 D458_Resistant_DMSO_3"
    "GSM3466128 D458_Resistant_DMSO_4"
    "GSM3466129 D458_Resistant_DMSO_5"
    "GSM3466130 D458_Resistant_JQ1_1"
    "GSM3466131 D458_Resistant_JQ1_2"
    "GSM3466132 D458_Resistant_JQ1_3"
    "GSM3466133 D458_Resistant_JQ1_4"
    "GSM3466134 D458_Resistant_JQ1_5"
]

# 903.463 ns (22 allocations: 1.23 KiB)
#@btime Omics.GEO.get_sample(BL_TH);

# ---- #

@test Omics.GEO.get_characteristic(BL_TH) == (
    ["cell type"],
    [
        "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"
    ],
)

# 10.625 μs (746 allocations: 18.09 KiB)
#@btime Omics.GEO.get_characteristic(BL_TH);

# ---- #

@test Omics.GEO.get_platform(BL_TH) === PL

# 36.924 ns (2 allocations: 64 bytes)
#@btime Omics.GEO.get_platform(BL_TH);

# ---- #

@test size.(Omics.GEO.get_feature(BL_TH, PL)) === ((53617,), (20,), (53617, 20))

# 223.606 ms (4829306 allocations: 463.28 MiB)
#@btime Omics.GEO.get_feature(BL_TH, PL);

# ---- #

const FE_GE = Omics.GEO.get_feature_map(BL_TH, PL)

@test length(FE_GE) === 17623

# 266.525 ms (2936036 allocations: 226.96 MiB)
#@btime Omics.GEO.get_feature_map(BL_TH, PL);

# ---- #

for (gs, nt, rc, rf) in (
    ("GSE13534", "", (0, 4), (14295, 4)),
    ("GSE16059", "diagnonsis", (3, 88), (31773, 88)),
    ("GSE67311", "diagnosis", (9, 142), (31403, 142)),
)

    sa_, ch_, vc, nf, fe_, vf = Omics.GEO.read_process_write_plot(
        mkpath(joinpath(tempdir(), gs)),
        joinpath(DA, Omics.GEO.make_soft(gs));
        nt,
    )

    @test size(vc) === rc

    @test size(vf) === rf

end
