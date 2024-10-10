module Palette

using ColorSchemes: ColorScheme, bwr

using Colors: Colorant

using ..Omics

function make(st_)

    ColorScheme(map(st -> parse(Colorant, st), st_))

end

const MO = make([Omics.Color.GE])

const BI = make(["#006442", "#ffb61e"])

const CA = make([
    "#636efa",
    "#ef553b",
    "#00cc96",
    "#ab63fa",
    "#ffa15a",
    "#19d3f3",
    "#ff6692",
    "#b6e880",
    "#ff97ff",
    "#fecb52",
    Omics.Color.FA,
    Omics.Color.RE,
    Omics.Color.GR,
    Omics.Color.BL,
    Omics.Color.YE,
    Omics.Color.KB,
    Omics.Color.KG,
    Omics.Color.KR,
    Omics.Color.KO,
    Omics.Color.KP,
    Omics.Color.KY,
    Omics.Color.KE,
    Omics.Color.KW,
    Omics.Color.GE,
    Omics.Color.GP,
    Omics.Color.GB,
    Omics.Color.SR,
    Omics.Color.SG,
    Omics.Color.CR,
    Omics.Color.CB,
    Omics.Color.HU,
])

function pick(nu_)

    ty = eltype(nu_)

    if ty <: AbstractFloat

        bwr

    elseif ty <: Integer

        uu = lastindex(unique(nu_))

        if isone(uu)

            MO

        elseif uu == 2

            BI

        elseif 2 < uu

            CA

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
