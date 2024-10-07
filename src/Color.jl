module Color

using Colors: Colorant, coloralpha, hex

const FA = "#ebf6f7"

const RE = "#ff1992"

const GR = "#93ff92"

const BL = "#1993ff"

const YE = "#ffff32"

const KB = "#dd9159"

const KG = "#6c9956"

const KR = "#e06351"

const KO = "#fc7f31"

const KP = "#561649"

const KY = "#fbb92d"

const KE = "#a40522"

const KW = "#790505"

const GE = "#20d9ba"

const GP = "#9017e6"

const GB = "#4e40d8"

const SR = "#8c1515"

const SG = "#175e54"

const CR = "#f47983"

const CB = "#003171"

function pars(st)

    parse(Colorant, st)

end

function hexify(rg)

    "#$(lowercase(hex(rg, :AUTO)))"

end

function fade(st, al)

    hexify(coloralpha(pars(st), al))

end

end
