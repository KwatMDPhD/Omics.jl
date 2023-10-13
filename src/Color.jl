module Color

using Base: _getch
using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, coloralpha, hex

using ..BioLab

const HEFA = "#ebf6f7"

const HEAG = "#00936e"

const HEAY = "#ffd96a"

const HEBL = "#1993ff"

const HERE = "#ff1992"

const HESR = "#8c1515"

const HESG = "#175e54"

function _co(he_)

    ColorScheme(parse.(Colorant, he_))

end

const COAS = _co([HEAG, "#a4e2b4", "#e0f5e5", "#ffffff", "#fff8d1", "#ffec9f", HEAY])

const COBW = bwr

const COPA = plasma

const COMO = _co(["#fc7f31"])

const COBI = _co(["#006442", "#ffb61e"])

const COPO = _co([
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
])

function _he(rg)

    "#$(lowercase(hex(rg, :AUTO)))"

end

function add_alpha(he, al)

    _he(coloralpha(parse(Colorant, he), al))

end

function _nu(an_)

    length(unique(an_))

end

function pick_color_scheme(nu_)

    ty = eltype(nu_)

    if ty <: AbstractFloat

        COBW

    elseif ty <: Integer

        n = _nu(nu_)

        if iszero(n) || isone(n)

            COMO

        elseif n == 2

            COBI

        else

            COPO

        end

    else

        error("`$nu_`'s element type `$ty` is not `AbstractFloat` or `Integer`.")

    end

end

function color(nu::Real, co)

    _he(co[nu])

end

function color(nu_, co = pick_color_scheme(nu_))

    if isone(_nu(nu_))

        return [color(0.5, co)]

    end

    mi, ma = BioLab.Collection.get_minimum_maximum(nu_)

    (nu -> color((nu - mi) / (ma - mi), co)).(nu_)

end

function fractionate(co)

    he_ = _he.(co)

    n = length(he_)

    if isone(n)

        push!(he_, he_[1])

        n += 1

    end

    collect(zip(range(0, 1, n), he_))

end

end
