using Test: @test

using Omics

# ---- #

const DA = joinpath(pkgdir(Omics), "data", "GEO")

# ---- #

const SO = Omics.GEO.make_soft("GSE122404")

@test SO === "GSE122404_family.soft.gz"

# ---- #

# 369.247 ms (10622 allocations: 54.01 MiB)

const GZ = joinpath(DA, SO)

const BL_TH = Omics.GEO.rea(GZ)

#@btime Omics.GEO.rea(GZ);

# ---- #

const PL = "GPL16686"

# ---- #

@test collect(keys(BL_TH["PLATFORM"])) == [PL]

@test length(BL_TH["PLATFORM"][PL]) === 48

@test parse(Int, BL_TH["PLATFORM"][PL]["!Platform_data_row_count"]) ===
      lastindex(collect(Omics.GEO._each(BL_TH["PLATFORM"][PL]["bo"]))) ===
      53981

# ---- #

# 903.526 ns (22 allocations: 1.23 KiB)

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 37

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

#@btime Omics.GEO.get_sample(BL_TH);

# ---- #

# 4.446 μs (6 allocations: 768 bytes)

@test Omics.GEO.get_characteristic(BL_TH) == (
    ["cell type"],
    [
        "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"
    ],
)

#@btime Omics.GEO.get_characteristic(BL_TH);

# ---- #

# 211.504 ms (4829272 allocations: 456.40 MiB)

@test size.(Omics.GEO.get_feature(BL_TH, PL)) === ((53617,), (20,), (53617, 20))

#@btime Omics.GEO.get_feature(BL_TH, PL);

# ---- #

# 264.113 ms (2744082 allocations: 224.43 MiB)

@test length(Omics.GEO.ma(BL_TH, PL)) === 17623

#@btime Omics.GEO.ma(BL_TH, PL);

# ---- #

for (gs, nt, r1, r2) in (
    ("GSE13534", "", (0, 4), (14295, 4)),
    ("GSE16059", "diagnonsis", (3, 88), (31773, 88)),
    ("GSE67311", "diagnosis", (9, 142), (31403, 142)),
)

    #@test size(vc) === r1

    #@test size(vf) === r2

end
