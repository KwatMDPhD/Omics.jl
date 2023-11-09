using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "GEO")

# ---- #

@test readdir(DA) == [
    "GSE122404_family.soft.gz"
    "GSE128078_family.soft.gz"
    "GSE13534_family.soft.gz"
    "GSE14577_family.soft.gz"
    "GSE16059_family.soft.gz"
    "GSE197763_family.soft.gz"
    "GSE67311_family.soft.gz"
]

# ---- #

const SO = joinpath(DA, "GSE122404_family.soft.gz")

# ---- #

const BL_TH = Nucleus.GEO.read(SO)

# ---- #

@test collect(keys(BL_TH["PLATFORM"])) == ["GPL16686"]

# ---- #

@test length(BL_TH["PLATFORM"]["GPL16686"]) === 47

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

# 586.246 ms (10649 allocations: 27.73 MiB)
#@btime Nucleus.GEO.read(SO);

# ---- #

@test Nucleus.GEO.get_sample(BL_TH) == [
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
#@btime Nucleus.GEO.get_sample(BL_TH);
#disable_logging(Debug);

# ---- #

@test Nucleus.GEO.get_characteristic(BL_TH) == (
    ["Cell Type"],
    ["D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 sensitive" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant" "D458 drug tolerant"],
)

# ---- #

# 3.875 μs (9 allocations: 936 bytes)
#disable_logging(Info);
#@btime Nucleus.GEO.get_characteristic(BL_TH);
#disable_logging(Debug);

# ---- #

@test size.(Nucleus.GEO.get_feature(BL_TH)) === ((53981,), (20,), (53981, 20))

# ---- #

# 375.446 ms (2577468 allocations: 383.49 MiB)
#disable_logging(Info);
#@btime Nucleus.GEO.get_feature(BL_TH);
#disable_logging(Debug);

# ---- #

for (gs, re, pl_re, ch) in (
    ("GSE197763", (4, 126), ("GPL18573" => nothing, "GPL24676" => nothing), ""),
    ("GSE13534", (0, 4), ("" => (22283, 4),), ""),
    ("GSE16059", (3, 88), ("" => (54675, 88),), "Diagnonsis"),
    ("GSE67311", (9, 142), ("" => (33297, 142),), "Irritable Bowel Syndrome"),
)

    so = joinpath(DA, "$(gs)_family.soft.gz")

    bl_th = Nucleus.GEO.read(so)

    sa_ = Nucleus.GEO.get_sample(bl_th)

    ch_, ch_x_sa_x_st = Nucleus.GEO.get_characteristic(bl_th)

    @test size(ch_x_sa_x_st) === re

    for (pl, re) in pl_re

        if isnothing(re)

            @test Nucleus.Error.@is Nucleus.GEO.get_feature(bl_th, pl)

        else

            fe_, is_, fe_x_sa_x_fl = Nucleus.GEO.get_feature(bl_th)

            @test view(sa_, is_) == sa_

            @test size(fe_x_sa_x_fl) === re

            Nucleus.GEO.write(
                mkdir(joinpath(Nucleus.TE, gs)),
                gs,
                sa_,
                ch_,
                ch_x_sa_x_st,
                fe_,
                fe_x_sa_x_fl;
                ch,
            )

        end

    end

end
