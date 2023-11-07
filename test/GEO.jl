using Test: @test

using Nucleus

# ---- #

const GS = "GSE122404"

# ---- #

const DW = joinpath(homedir(), "Downloads")

# ---- #

const GZ = joinpath(DW, "$(GS)_family.soft.gz")

# ---- #

if !isfile(GZ)

    @test Nucleus.GEO.download(DW, GS) === GZ

end

# ---- #

const BL_TH = Nucleus.GEO.read(GZ)

# ---- #

@test collect(keys(BL_TH["DATABASE"])) == ["GeoMiame"]

# ---- #

@test length(BL_TH["DATABASE"]["GeoMiame"]) === 4

# ---- #

@test collect(keys(BL_TH["SERIES"])) == [GS]

# ---- #

@test length(BL_TH["SERIES"][GS]) === 44

# ---- #

const PL = "GPL16686"

# ---- #

@test BL_TH["SERIES"][GS]["!Series_platform_id"] === PL

# ---- #

const SM_ = [
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

@test [va for (ke, va) in BL_TH["SERIES"][GS] if startswith(ke, "!Series_sample_id")] == SM_

# ---- #

@test BL_TH["SERIES"][GS]["!Series_supplementary_file"] ===
      "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE122nnn/$GS/suppl/GSE122404_RAW.tar"

# ---- #

@test collect(keys(BL_TH["PLATFORM"])) == [PL]

# ---- #

const KE_VA = BL_TH["PLATFORM"][PL]

# ---- #

@test length(KE_VA) === 47

# ---- #

const SA_KE_VA = BL_TH["SAMPLE"]

# ---- #

@test collect(keys(SA_KE_VA)) == SM_

# ---- #

const SA = SM_[1]

# ---- #

@test length(SA_KE_VA[SA]) === 36

# ---- #

# 586.246 ms (10649 allocations: 27.73 MiB)
#@btime Nucleus.GEO.read(GZ);

# ---- #

# 11.500 ms (107248 allocations: 16.70 MiB)
#@btime Nucleus.GEO._dice($(SA_KE_VA[SA]["_ta"]));

# ---- #

const SA_ = Nucleus.GEO.get_sample(SA_KE_VA)

# ---- #

const N_SA = lastindex(SM_)

# ---- #

@test lastindex(SA_) === N_SA

# ---- #

# 314.583 ns (1 allocation: 208 bytes)
#@btime Nucleus.GEO.get_sample(SA_KE_VA);

# ---- #

const CH_, CH_X_SA_X_ST = Nucleus.GEO.tabulate(SA_KE_VA)

# ---- #

@test size(CH_X_SA_X_ST) === (lastindex(CH_), N_SA)

# ---- #

# 3.849 μs (9 allocations: 936 bytes)
#@btime Nucleus.GEO.tabulate(SA_KE_VA);

# ---- #

const FE_, SAF_, FE_X_SA_X_FL = Nucleus.GEO.tabulate(KE_VA, SA_KE_VA)

# ---- #

@test size(FE_X_SA_X_FL) === (lastindex(FE_), N_SA)

# ---- #

# 377.606 ms (2541408 allocations: 383.30 MiB)
#@btime Nucleus.GEO.tabulate(KE_VA, SA_KE_VA);

# ---- #

for (gs, re, pl_re) in (
    ("GSE197763", (4, 126), ("GPL18573" => nothing, "GPL24676" => nothing)),
    ("GSE13534", (0, 4), ("GPL96" => (22283, 4),)),
)

    gz = joinpath(DW, "$(gs)_family.soft.gz")

    if !isfile(gz)

        @test Nucleus.GEO.download(DW, gs) === gz

    end

    bl_th = Nucleus.GEO.read(gz)

    sa_ke_va = bl_th["SAMPLE"]

    sa_ = Nucleus.GEO.get_sample(sa_ke_va)

    ch_, ch_x_sa_x_st = Nucleus.GEO.tabulate(sa_ke_va)

    @test size(ch_x_sa_x_st) === re

    for (pl, re) in pl_re

        ke_va = bl_th["PLATFORM"][pl]

        if isnothing(re)

            @test Nucleus.Error.@is Nucleus.GEO.tabulate(ke_va, sa_ke_va)

        else

            fe_, is_, fe_x_sa_x_fl = Nucleus.GEO.tabulate(ke_va, sa_ke_va)

            @test view(sa_, is_) == sa_

            @test size(fe_x_sa_x_fl) === re

        end

    end

end

# ---- #

const GS2 = "GSE14577"

# ---- #

@test Nucleus.Error.@is Nucleus.GEO.write(DW, GS2)

# ---- #

for pl in ("GPL96", "GPL97")

    Nucleus.GEO.write(DW, GS2, pl)

end

# ---- #

for (gs, ts, lo, ch) in (
    ("GSE16059", "", false, "Diagnonsis"),
    ("GSE67311", "", false, "Irritable Bowel Syndrome"),
    (
        "GSE128078",
        download(
            "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE128nnn/GSE128078/suppl/GSE128078%5FFES%5Fisoforms%5FFPKM%2Etxt%2Egz",
            joinpath(DW, "feature.txt.gz"),
        ),
        true,
        "Disease State",
    ),
    #("GSE130353", "", false, ""),
)

    Nucleus.GEO.write(DW, gs; ts, lo, nas = "$(lowercase(gs))sample", ch)

end
