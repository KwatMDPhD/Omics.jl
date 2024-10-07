module Palette

using ColorSchemes: ColorScheme, bwr

using ..Omics

function make(he_)

    #ColorScheme(map(Omics.Color.parse, he_))
    ColorScheme(he_)

end

const MO = make([GP])

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
    FA,
    RE,
    GR,
    BL,
    YE,
    KB,
    KG,
    KR,
    KO,
    KP,
    KY,
    KE,
    KW,
    GE,
    GP,
    GB,
    SR,
    SG,
    CR,
    CB,
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

function color(nu::Real, pa)

    Omics.Color.hexify(pa[nu])

end

function color(nu_, pa = pick(nu_))

    if isempty(nu_)

        String[]

    elseif isone(lastindex(unique(nu_)))

        [color(0.5, pa)]

    else

        mi = minimum(nu_)

        ma = maximum(nu_)

        map(nu -> color((nu - mi) / (ma - mi), pa), nu_)

    end

end

function fractionate(pa)

    he_ = map(Omics.Color.hexify, pa)

    uh = lastindex(he_)

    if isone(uh)

        he = he_[]

        [(0, he), (1, he)]

    else

        collect(zip(range(0, 1, uh), he_))

    end

end

end
