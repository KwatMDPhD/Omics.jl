include("_.jl")

# ---- #

dip = mkpath(joinpath(tempdir(), "Present"))

BioLab.Path.empty(dip)

@test isdir(dip) && length(readdir(dip)) == 0

dia = joinpath(tempdir(), "Absent")

BioLab.Path.empty(dia)

@test isdir(dia) && length(readdir(dia)) == 0

@code_warntype BioLab.Path.empty(dia)
