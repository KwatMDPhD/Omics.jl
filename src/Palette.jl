module Palette

using ColorSchemes: ColorScheme, bwr

using Colors: Colorant

using ..Omics

function make(st_)

    ColorScheme([parse(Colorant, st) for st in st_])

end

function pick(nu_)

    ty = eltype(nu_)

    if ty <: AbstractFloat

        bwr

    elseif ty <: Integer

        uu = lastindex(unique(nu_))

        if isone(uu)

            make((Omics.Color.RE,))

        elseif uu == 2

            make((Omics.Color.LI, Omics.Color.DA))

        elseif 2 < uu

            make(
                (
                    Omics.Color.RE,
                    Omics.Color.GR,
                    Omics.Color.BL,
                    Omics.Color.YE,
                    Omics.Color.MA,
                    Omics.Color.CY,
                    Omics.Color.IN,
                    Omics.Color.CH,
                    Omics.Color.MO,
                    Omics.Color.KO,
                    Omics.Color.TU,
                    Omics.Color.VI,
                    Omics.Color.OR,
                    Omics.Color.PU,
                    Omics.Color.HU,
                    Omics.Color.S1,
                    Omics.Color.S2,
                    Omics.Color.LI,
                    Omics.Color.DA,
                    Omics.Color.AK,
                    Omics.Color.KA,
                )[1:uu],
            )

        end

    end

end

function color(nu::Real, rg_)

    Omics.Color.hexify(rg_[nu])

end

function color(nu_, rg_ = pick(nu_))

    if isempty(nu_)

        error()

    elseif isone(lastindex(unique(nu_)))

        [color(0.5, rg_)]

    else

        mi, ma = extrema(nu_)

        map(nu -> color((nu - mi) / (ma - mi), rg_), nu_)

    end

end

function fractionate(rg_)

    ur = lastindex(rg_)

    he_ = map(Omics.Color.hexify, rg_)

    if isone(ur)

        he = he_[]

        [(0, he), (1, he)]

    else

        collect(zip(range(0, 1, ur), he_))

    end

end

end
