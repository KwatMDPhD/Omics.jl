module Color

using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, coloralpha, hex

using ..BioLab

const HEFA = "#ebf6f7"

function _make_color_scheme(he_)

    ColorScheme(parse.(Colorant, he_))

end

const COAS = _make_color_scheme([
    "#00936e",
    "#a4e2b4",
    "#e0f5e5",
    "#ffffff",
    "#fff8d1",
    "#ffec9f",
    "#ffd96a",
])

const COBW = bwr

const COPA = plasma

const COMO = _make_color_scheme(["#fbb92d"])

const COBI = _make_color_scheme(["#006442", "#ffb61e"])

const COST = _make_color_scheme(["#8c1515", "#175e54"])

const COHU = _make_color_scheme(["#4b3c39", "#ffddca"])

const COPO = _make_color_scheme([
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

function _make_hex(rg, st = :AUTO)

    "#$(lowercase(hex(rg, st)))"

end

function add_alpha(he, al)

    _make_hex(coloralpha(parse(Colorant, he), al))

end

function pick_color_scheme(nu_)

    ty = eltype(nu_)

    if ty <: AbstractFloat

        COBW

    elseif ty <: Integer

        n = length(unique(nu_))

        if iszero(n) || isone(n)

            COMO

        elseif n == 2

            COBI

        else

            COPO

        end

    else

        error("`$nu_`'s element type is not `AbstractFloat` or `Integer`.")

    end

end

function color(nu::Real, co)

    _make_hex(co[nu])

end

function color(nu_, co = pick_color_scheme(nu_))

    if isone(length(unique(nu_)))

        return [color(0.5, co)]

    end

    mi, ma = BioLab.Collection.get_minimum_maximum(nu_)

    (nu_ -> color((nu_ - mi) / (ma - mi), co)).(nu_)

end

function fractionate(co)

    he_ = _make_hex.(co)

    n = length(he_)

    if isone(n)

        return [(0.5, he_[1])]

    end

    collect(zip(range(0, 1, n), he_))

end

end
