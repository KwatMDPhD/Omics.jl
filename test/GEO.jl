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

const SO = joinpath(DA, "GSE122404_family.soft.gz")

# ---- #

const BL_TH = Nucleus.GEO._read(SO)

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

# 587.372 ms (10649 allocations: 27.73 MiB)
#@btime Nucleus.GEO._read(SO);

# ---- #

@test Nucleus.GEO._get_sample(BL_TH) == [
    "D458_Sensitive_DMSO_1"
    "D458_Sensitive_DMSO_2"
    "D458_Sensitive_DMSO_3"
    "D458_Sensitive_DMSO_4"
    "D458_Sensitive_DMSO_5"
    "D458_Sensitive_JQ1_1"
    "D458_Sensitive_JQ1_2"
    "D458_Sensitive_JQ1_3"
    "D458_Sensitive_JQ1_4"
    "D458_Sensitive_JQ1_5"
    "D458_Resistant_DMSO_1"
    "D458_Resistant_DMSO_2"
    "D458_Resistant_DMSO_3"
    "D458_Resistant_DMSO_4"
    "D458_Resistant_DMSO_5"
    "D458_Resistant_JQ1_1"
    "D458_Resistant_JQ1_2"
    "D458_Resistant_JQ1_3"
    "D458_Resistant_JQ1_4"
    "D458_Resistant_JQ1_5"
]

# ---- #

# 333.144 ns (1 allocation: 208 bytes)
#disable_logging(Info);
#@btime Nucleus.GEO._get_sample(BL_TH);
#disable_logging(Debug);

# ---- #

@test Nucleus.GEO._get_characteristic(BL_TH) == (
    ["Cell Type"],
    ["D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"],
)

# ---- #

# 3.839 μs (9 allocations: 936 bytes)
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

@test size.(Nucleus.GEO._get_feature(BL_TH, PL)) === ((53617,), (20,), (53617, 20))

# ---- #

# 371.853 ms (2524009 allocations: 383.42 MiB)
#disable_logging(Info);
#@btime Nucleus.GEO._get_feature(BL_TH, PL);
#disable_logging(Debug);

# ---- #

@test Nucleus.Error.@is Nucleus.GEO.intersect(1:2, 3:5, [1 2], [3 4 5])

# ---- #

for (co1_, co2_, ma1, ma2, re) in (
    (1:1, 1:2, [1;;], [1 2], (1:1, [1;;], [1;;])),
    (1:2, 1:2, [1 2], [1 2], (1:2, [1 2], [1 2])),
    (1:3, 2:4, [1 2 3], [2 3 4], (2:3, [2 3], [2 3])),
)

    @test Nucleus.GEO.intersect(co1_, co2_, ma1, ma2) == re

    # 283.514 ns (14 allocations: 1.38 KiB)
    # 290.047 ns (14 allocations: 1.41 KiB)
    # 320.500 ns (14 allocations: 1.41 KiB)
    #disable_logging(Info)
    #@btime Nucleus.GEO.intersect($co1_, $co2_, $ma1, $ma2)
    #disable_logging(Debug)

end

# ---- #

for (gs, ch, rec, ref) in (
    ("GSE13534", "", (0, 4), (14295, 4)),
    ("GSE16059", "Diagnonsis", (3, 88), (31773, 88)),
    ("GSE67311", "Diagnosis", (9, 142), (31403, 142)),
    # TODO: Add a test data that has a different number of samples.
)

    so = "$(gs)_family.soft.gz"

    sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_fl =
        Nucleus.GEO.get(cp(joinpath(DA, so), joinpath(Nucleus.TE, so)), ch)

    @test size(ch_x_sa_x_st) === rec

    @test size(fe_x_sa_x_fl) === ref

end

# ---- #

for (gs, re) in (("GSE168940", (5, 18)), ("GSE197763", (4, 126)))

    bl_th, sa_, ch_, ch_x_sa_x_st =
        Nucleus.GEO.get_sample_characteristic(joinpath(DA, "$(gs)_family.soft.gz"))

    @test size(ch_x_sa_x_st) === re

    for pl in keys(bl_th["PLATFORM"])

        @test Nucleus.Error.@is Nucleus.GEO._get_platform(bl_th)

    end

end
