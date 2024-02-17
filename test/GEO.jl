using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "GEO")

# ---- #

@test readdir(DA) == [
    "GSE122404_family.soft.gz",
    "GSE128078_family.soft.gz",
    "GSE13534_family.soft.gz",
    "GSE14577_family.soft.gz",
    "GSE16059_family.soft.gz",
    "GSE168940_family.soft.gz",
    "GSE197763_family.soft.gz",
    "GSE67311_family.soft.gz",
]

# ---- #

const SO = Nucleus.GEO.make_soft("GSE122404")

# ---- #

@test SO === "GSE122404_family.soft.gz"

# ---- #

const PA = joinpath(DA, SO)

# ---- #

const BL_TH = Nucleus.GEO._read(PA)

# ---- #

const PL = "GPL16686"

# ---- #

@test collect(keys(BL_TH["PLATFORM"])) == [PL]

# ---- #

@test length(BL_TH["PLATFORM"][PL]) === 47

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

@test length(BL_TH["SAMPLE"]["GSM3466115"]) === 36

# ---- #

# 587.345 ms (10649 allocations: 27.73 MiB)
#@btime Nucleus.GEO._read(PA);

# ---- #

@test Nucleus.GEO._get_sample(BL_TH) == [
    "GSM3466115_D458_Sensitive_DMSO_1"
    "GSM3466116_D458_Sensitive_DMSO_2"
    "GSM3466117_D458_Sensitive_DMSO_3"
    "GSM3466118_D458_Sensitive_DMSO_4"
    "GSM3466119_D458_Sensitive_DMSO_5"
    "GSM3466120_D458_Sensitive_JQ1_1"
    "GSM3466121_D458_Sensitive_JQ1_2"
    "GSM3466122_D458_Sensitive_JQ1_3"
    "GSM3466123_D458_Sensitive_JQ1_4"
    "GSM3466124_D458_Sensitive_JQ1_5"
    "GSM3466125_D458_Resistant_DMSO_1"
    "GSM3466126_D458_Resistant_DMSO_2"
    "GSM3466127_D458_Resistant_DMSO_3"
    "GSM3466128_D458_Resistant_DMSO_4"
    "GSM3466129_D458_Resistant_DMSO_5"
    "GSM3466130_D458_Resistant_JQ1_1"
    "GSM3466131_D458_Resistant_JQ1_2"
    "GSM3466132_D458_Resistant_JQ1_3"
    "GSM3466133_D458_Resistant_JQ1_4"
    "GSM3466134_D458_Resistant_JQ1_5"
]

# ---- #

# 1.042 μs (21 allocations: 1.22 KiB)
#disable_logging(Info);
#@btime Nucleus.GEO._get_sample(BL_TH);
#disable_logging(Debug);

# ---- #

@test Nucleus.GEO._get_characteristic(BL_TH) == (
    ["Platform", "Cell Type"],
    [
         "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686" "GPL16686"
        "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"
    ],
)

# ---- #

# 10.666 μs (13 allocations: 1.45 KiB)
#disable_logging(Info);
#@btime Nucleus.GEO._get_characteristic(BL_TH);
#disable_logging(Debug);

# ---- #

@test Nucleus.Error.@is Nucleus.GEO._get_platform(
    Nucleus.GEO._read(joinpath(DA, "GSE168940_family.soft.gz")),
)

# ---- #

@test Nucleus.GEO._get_platform(BL_TH) === PL

# ---- #

@test size.(Nucleus.GEO._get_feature(BL_TH, PL)) === ((17623,), (20,), (17623, 20))

# ---- #

# 370.710 ms (2378577 allocations: 372.10 MiB)
#disable_logging(Info);
#@btime Nucleus.GEO._get_feature(BL_TH, PL);
#disable_logging(Debug);

# ---- #

@test Nucleus.Error.@is Nucleus.GEO.intersect(1:2, 3:5, [1 2], [3 4 5])

# ---- #

for (c1_, c2_, m1, m2, re) in (
    (1:1, 1:2, [1;;], [1 2], (1:1, [1;;], [1;;])),
    (1:2, 1:2, [1 2], [1 2], (1:2, [1 2], [1 2])),
    (1:3, 2:4, [1 2 3], [2 3 4], (2:3, [2 3], [2 3])),
)

    @test Nucleus.GEO.intersect(c1_, c2_, m1, m2) == re

    # 283.576 ns (14 allocations: 1.38 KiB)
    # 294.370 ns (14 allocations: 1.41 KiB)
    # 325.658 ns (14 allocations: 1.41 KiB)
    #disable_logging(Info)
    #@btime Nucleus.GEO.intersect($c1_, $c2_, $m1, $m2)
    #disable_logging(Debug)

end

# ---- #

for (gs, ch, rs, rf) in (
    ("GSE13534", "", (1, 4), (13237, 4)),
    ("GSE16059", "Diagnonsis", (4, 88), (22880, 88)),
    ("GSE67311", "Diagnosis", (10, 142), (20254, 142)),
    # TODO: Add a test data that has a different number of samples.
)

    sa_, ch_, st, pl, fe_, fl =
        Nucleus.GEO.get(Nucleus.TE, joinpath(DA, Nucleus.GEO.make_soft(gs)); ch)

    @test size(st) === rs

    @test size(fl) === rf

end

# ---- #

for (gs, re) in (("GSE168940", (6, 18)), ("GSE197763", (5, 126)))

    bl_th, sa_, ch_, st =
        Nucleus.GEO.get_sample_characteristic(joinpath(DA, "$(gs)_family.soft.gz"))

    @test size(st) === re

    for pl in keys(bl_th["PLATFORM"])

        @test Nucleus.Error.@is Nucleus.GEO._get_platform(bl_th)

    end

end
