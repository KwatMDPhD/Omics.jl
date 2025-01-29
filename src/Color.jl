module Color

using Colors: Colorant, coloralpha, hex

const RE = "#ff1993"

const GR = "#92ff93"

const BL = "#1992ff"

const YE = "#ffff93"

const MA = "#ff23ff"

const CY = "#92ffff"

const HU = "#fbb92d"

const AG = "#00936e"

const AY = "#ffd96a"

const LI = "#ebf6f7"

const BR = "#4c221b"

const DA = "#27221f"

const IN = "#4e40d8"

const CH = "#a40522"

const MO = "#f47983"

const KO = "#003171"

const TU = "#20d9ba"

const VI = "#9017e6"

const OR = "#fc7f31"

const PU = "#561649"

const SR = "#8c1515"

const SG = "#175e54"

function hexify(rg::Colorant)

    "#$(hex(rg, :rrggbbaa))"

end

function hexify(st, al = 1.0)

    hexify(coloralpha(parse(Colorant, st), al))

end

end
