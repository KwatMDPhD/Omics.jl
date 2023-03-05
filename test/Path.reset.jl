include("_.jl")

# ----------------------------------------------------------------------------------------------- #

dip = mkpath(joinpath(tempdir(), "Present"))

BioLab.Path.reset(dip)

@test isdir(dip) && length(readdir(dip)) == 0

dia = joinpath(tempdir(), "Absent")

BioLab.Path.reset(dia)

@test isdir(dia) && length(readdir(dia)) == 0

@code_warntype BioLab.Path.reset(dia)
