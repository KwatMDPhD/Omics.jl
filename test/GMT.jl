include("_.jl")

# ----------------------------------------------------------------------------------------------- #

da = joinpath(@__DIR__, "gmt.data")

gm1 = joinpath(da, "h.all.v7.1.symbols.gmt")

gm2 = joinpath(da, "c2.all.v7.1.symbols.gmt")

n = 2

for gm in (gm1, gm2)

    BioLab.print_header(gm)

    # TODO: `@test`.
    BioLab.Dict.print(BioLab.GMT.read(gm); n)

    # @code_warntype BioLab.GMT.read(gm)

end

# ----------------------------------------------------------------------------------------------- #

# TODO: `@test`.
BioLab.Dict.print(BioLab.GMT.read((gm1, gm1)); n)

gm_ = (gm1, gm2)

# TODO: `@test`.
BioLab.Dict.print(BioLab.GMT.read(gm_); n)

# @code_warntype BioLab.GMT.read(gm_)
