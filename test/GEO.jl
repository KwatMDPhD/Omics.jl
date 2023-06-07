include("environment.jl")

# ---- #

gs = "GSE122404"

# ---- #

ty_bl = BioLab.GEO.read(gs)

@test length(ty_bl["DATABASE"]) == 1

@test length(ty_bl["DATABASE"]["GeoMiame"]) == 4

@test length(ty_bl["SERIES"]) == 1

@test length(ty_bl["SERIES"]["GSE122404"]) == 44

@test length(ty_bl["SAMPLE"]) == 20

@test length(ty_bl["SAMPLE"]["GSM3466115"]) == 36

@test size(BioLab.DataFrame.make(ty_bl["SAMPLE"]["GSM3466115"]["table"])) == (53617, 2)

@test length(ty_bl["PLATFORM"]) == 1

@test length(ty_bl["PLATFORM"]["GPL16686"]) == 47

@test size(BioLab.DataFrame.make(ty_bl["PLATFORM"]["GPL16686"]["table"])) == (53981, 8)

# 639.308 ms (3441196 allocations: 208.36 MiB)
# @btime BioLab.GEO.read($gs);

# ---- #

pl_ke_va = ty_bl["PLATFORM"]

pl = collect(keys(pl_ke_va))[1]

fe_x_io_x_an = BioLab.DataFrame.make(pl_ke_va[pl]["table"])

fe_na = BioLab.GEO._name(pl, fe_x_io_x_an)

@test fe_na["16657485"] == "XR_132471"

# 9.955 ms (448393 allocations: 18.95 MiB)
# @btime fe_na = BioLab.GEO._name($pl, $fe_x_io_x_an);

# ---- #

fe_x_sa_x_an, fe_x_sa_x_nu_____... = BioLab.GEO.tabulate(ty_bl)

# 641.084 ms (9242747 allocations: 892.22 MiB)
# @btime BioLab.GEO.tabulate($ty_bl);

# ---- #

for gs in ("GSE13534", "GSE107011", "GSE168204", "GSE141484")

    ty_bl = BioLab.GEO.read(gs)

    fe_x_sa_x_an, fe_x_sa_x_nu_____... = BioLab.GEO.tabulate(ty_bl)

end
