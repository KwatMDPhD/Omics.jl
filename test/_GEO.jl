include("_.jl")

# ---- #

gs = "GSE122404"

# TODO: `@test`.
ty_bl = BioLab.GEO.read(gs)

# @code_warntype BioLab.GEO.read(gs)

# 897.817 ms (10424941 allocations: 814.04 MiB)
# @btime BioLab.GEO.read($gs; pr = $false)

# ---- #

pl_ke_va = ty_bl["PLATFORM"]

pl = collect(keys(pl_ke_va))[1]

println(pl)

fe_x_io_x_an = pl_ke_va[pl]["fe_x_io_x_an"]

fe_na = BioLab.GEO._name(pl, fe_x_io_x_an)

@test fe_na["16657485"] == "XR_132471"

# @code_warntype BioLab.GEO._name(pl, fe_x_io_x_an)

# 13.012 ms (287563 allocations: 10.75 MiB)
# @btime BioLab.GEO._name($pl, $fe_x_io_x_an; pr = $false)

# ---- #

# TODO: `@test`.
fe_x_sa_x_an, fe_x_sa_x_nu_____... = BioLab.GEO.tabulate(ty_bl)

# @code_warntype BioLab.GEO.tabulate(ty_bl)

# 162.249 ms (360569 allocations: 139.39 MiB)
# @btime BioLab.GEO.tabulate($ty_bl; pr = $false)

# ---- #

pr = false

for gs in ("GSE13534", "GSE107011", "GSE168204", "GSE141484")

    BioLab.print_header(gs)

    ty_bl = BioLab.GEO.read(gs; pr)

    fe_x_sa_x_an, fe_x_sa_x_nu_____... = BioLab.GEO.tabulate(ty_bl; pr)

end
