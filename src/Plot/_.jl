module Plot

using ColorSchemes: ColorScheme

using Colors: Colorant, hex

using DataFrames

using JSON3: write

using ..OnePiece

NA_CO = Dict()

for (na, he_) in [
    [
        "Plasma",
        [
            "#0d0887",
            "#46039f",
            "#7201a8",
            "#9c179e",
            "#bd3786",
            "#d8576b",
            "#ed7953",
            "#fb9f3a",
            "#fdca26",
            "#f0f921",
        ],
    ],
    [
        "Plotly3",
        [
            "#0508b8",
            "#1910d8",
            "#3c19f0",
            "#6b1cfb",
            "#981cfd",
            "#bf1cfd",
            "#dd2bfd",
            "#f246fe",
            "#fc67fd",
            "#fe88fc",
            "#fea5fd",
            "#febefe",
            "#fec3fe",
        ],
    ],
    [
        "Plotly",
        [
            "#636EFA",
            "#EF553B",
            "#00CC96",
            "#AB63FA",
            "#FFA15A",
            "#19D3F3",
            "#FF6692",
            "#B6E880",
            "#FF97FF",
            "#FECB52",
        ],
    ],
    ["binary", ["#006442", "#ffffff", "#ffb61e"]],
    ["human", ["#4b3c39", "#ffffff", "#ffddca"]],
    ["stanford", ["#ffffff", "#8c1515"]],
]

    NA_CO[na] = ColorScheme([parse(Colorant, he) for he in he_])

end

include("../_include.jl")

@_include()

end
