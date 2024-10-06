module Color

using ColorSchemes: ColorScheme, bwr

using Colors: Colorant, coloralpha, hex

const DA = "#171412"

const FA = "#ebf6f7"

const RE = "#ff1992"

const GR = "#93ff92"

const BL = "#1993ff"

const YE = "#ffff32"

const GE = "#20d9ba"

const GP = "#9017e6"

const GB = "#4e40d8"

const SR = "#8c1515"

const SG = "#175e54"

const IR = "#fc7f31"

const IP = "#561649"

const BR = "#f47983"

const BB = "#003171"

function _parse(st)

    parse(Colorant, st)

end

function _hexify(rg)

    "#$(lowercase(hex(rg, :AUTO)))"

end

function fade(he, al)

    _hexify(coloralpha(_parse(he), al))

end

function make(he_)

    ColorScheme(map(_parse, he_))

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
    RE,
    GR,
    BL,
    YE,
    GE,
    GP,
    GB,
    SR,
    SG,
    IR,
    IP,
    BR,
    BB,
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

function color(nu::Real, co)

    _hexify(co[nu])

end

function color(nu_, co = pick(nu_))

    if isempty(nu_)

        String[]

    elseif isone(lastindex(unique(nu_)))

        [color(0.5, co)]

    else

        mi = minimum(nu_)

        ma = maximum(nu_)

        map(nu -> color((nu - mi) / (ma - mi), co), nu_)

    end

end

function fractionate(co)

    he_ = map(_hexify, co)

    uh = lastindex(he_)

    if isone(uh)

        he = he_[]

        [(0, he), (1, he)]

    else

        collect(zip(range(0, 1, uh), he_))

    end

end

end
