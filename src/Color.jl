module Color

using Colors: Colorant, coloralpha, hex

const HU = "#fbb92d"

const LI = "#ebf6f7"

const DA = "#27221f"

const IN = "#4e40d8"

const CH = "#a40522"

const MO = "#f47983"

const KO = "#003171"

const TU = "#20d9ba"

const VI = "#9017e6"

const RE = "#ff1993"

const GR = "#92ff93"

const BL = "#1992ff"

const YE = "#ffff93"

const MA = "#ff23ff"

const CY = "#92ffff"

const A1 = "#00936e"

const A2 = "#ffd96a"

const S1 = "#8c1515"

const S2 = "#175e54"

function hexify(co::Colorant)

    "#$(hex(co, :rrggbbaa))"

end

function hexify(co)

    hexify(parse(Colorant, co))

end

function hexify(co, fr)

    hexify(coloralpha(parse(Colorant, co), fr))

end

end
