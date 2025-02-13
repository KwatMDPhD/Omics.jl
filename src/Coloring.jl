module Coloring

using ColorSchemes: ColorScheme

using Colors: Colorant

# Plotly.js
const PJ_ = (
    "#1f77b4",
    "#ff7f0e",
    "#2ca02c",
    "#d62728",
    "#9467bd",
    "#8c564b",
    "#e377c2",
    "#7f7f7f",
    "#bcbd22",
    "#17becf",
)

# Plotly.py
const PP_ = (
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
)

# IBM Light
const IL_ = (
    "#6929c5",
    "#1192e8",
    "#005d5d",
    "#9f1853",
    "#fa4d56",
    "#570408",
    "#198038",
    "#002d9c",
    "#ee538b",
    "#b28600",
    "#009d9a",
    "#012749",
    "#8a3800",
    "#a56eff",
)

# IBM Dark
const ID_ = (
    "#8a3ffc",
    "#33b1ff",
    "#007d79",
    "#ff7eb6",
    "#fa5d67",
    "#fff1f1",
    "#6fdc8c",
    "#4589ff",
    "#d12771",
    "#d2a106",
    "#08bdba",
    "#bae6ff",
    "#ba4e00",
    "#d4bbff",
)

# Spring Pastels
const SP_ = (
    "#fd7f6f",
    "#7eb0d5",
    "#b2e061",
    "#bd7ebe",
    "#ffb55a",
    "#ffee65",
    "#beb9db",
    "#fdcce5",
    "#8bd3c7",
)

# Dutch Field
const DU_ = (
    "#e60049",
    "#0bb4ff",
    "#50e991",
    "#e6d800",
    "#9b19f5",
    "#ffa300",
    "#dc0ab4",
    "#b3d4ff",
    "#00bfa0",
)

# River Nights
const RI_ = (
    "#b30000",
    "#7c1158",
    "#4421af",
    "#1a53ff",
    "#0d88e6",
    "#00b7c7",
    "#5ad45a",
    "#8be04e",
    "#ebdc78",
)

# Retro Metro
const RE_ = (
    "#ea5545",
    "#f46a9b",
    "#ef9b20",
    "#edbf33",
    "#ede15b",
    "#bdcf32",
    "#87bc45",
    "#27aeef",
    "#b33dc6",
)

function fractionate(co_)

    nu = lastindex(co_)

    if isone(nu)

        co = co_[1]

        ((0.0, co), (1.0, co))

    else

        Tuple(zip(range(0, 1, nu), co_))

    end

end

function make(co_)

    ColorScheme(map(co -> parse(Colorant, co), co_))

end

end
