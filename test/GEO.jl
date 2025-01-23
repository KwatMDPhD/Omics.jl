using Test: @test

using XSample

# ---- #

using Omics

# ---- #

const DA = joinpath(XSample._DA, "GEO")

# ---- #

@test readdir(DA) == [
    "GSE122404_family.soft.gz",
    "GSE13534_family.soft.gz",
    "GSE16059_family.soft.gz",
    "GSE168940_family.soft.gz",
    "GSE67311_family.soft.gz",
]

# ---- #

const SO = XSample.GEO.make_soft("GSE122404")

# ---- #

@test SO === "GSE122404_family.soft.gz"

# ---- #

const GZ = joinpath(DA, SO)

# ---- #

const BL_TH = XSample.GEO._read(GZ)

# ---- #

const PL = "GPL16686"

# ---- #

@test collect(keys(BL_TH["PLATFORM"])) == [PL]

# ---- #

@test length(BL_TH["PLATFORM"][PL]) === 48

# ---- #

@test parse(Int, BL_TH["PLATFORM"][PL]["!Platform_data_row_count"]) ===
      lastindex(collect(XSample.GEO._dicing(BL_TH["PLATFORM"][PL]["_ro"]))) ===
      53981

# ---- #

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

# ---- #

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 37

# ---- #

# 573.117 ms (10699 allocations: 27.75 MiB)
#@btime XSample.GEO._read(GZ);

# ---- #

@test XSample.GEO._get_sample(BL_TH) == [
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

# ---- #

# 1.067 μs (22 allocations: 1.42 KiB)
#disable_logging(Info);
#@btime XSample.GEO._get_sample(BL_TH);
#disable_logging(Debug);

# ---- #

@test XSample.GEO._get_characteristic(BL_TH) == (
    ["cell type"],
    [
        "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"
    ],
)

# ---- #

# 9.333 μs (6 allocations: 768 bytes)
#disable_logging(Info);
#@btime XSample.GEO._get_characteristic(BL_TH);
#disable_logging(Debug);

# ---- #

@test Omics.Error.@is XSample.GEO._get_platform(
    XSample.GEO._read(joinpath(DA, XSample.GEO.make_soft("GSE168940"))),
)

# ---- #

@test XSample.GEO._get_platform(BL_TH) === PL

# ---- #

# 38.432 ns (1 allocation: 64 bytes)
#disable_logging(Info);
#@btime XSample.GEO._get_platform(BL_TH);
#disable_logging(Debug);

# ---- #

# 1.500 ns (0 allocations: 0 bytes)
#@btime XSample.GEO._dicing($(BL_TH["PLATFORM"][PL]["_ro"]));

# ---- #

@test size.(XSample.GEO._get_feature(BL_TH, PL)) === ((53617,), (20,), (53617, 20))

# ---- #

# 351.175 ms (2253754 allocations: 319.63 MiB)
#disable_logging(Info);
#@btime XSample.GEO._get_feature(BL_TH, PL);
#disable_logging(Debug);

# ---- #

for (gs, ir, rs, rf) in (
    ("GSE13534", "", (0, 4), (14295, 4)),
    ("GSE16059", "diagnonsis", (3, 88), (31773, 88)),
    ("GSE67311", "diagnosis", (8, 142), (31403, 142)),
)

    sa_, ch_, cs, pl, fe_, fs =
        XSample.GEO.get(Omics.TE, joinpath(DA, XSample.GEO.make_soft(gs)); ir)

    @test size(cs) === rs

    @test size(fs) === rf

end
