module Plot

using ColorSchemes: ColorScheme, plasma

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON3: write

using ..OnePiece

NA_SC = Dict{String, ColorScheme}("plasma" => plasma)

for (na, he_) in Dict(
    "plotly3" => (
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
    ),
    "plotly" => (
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
    ),
    "binary" => ("#006442", "#ffffff", "#ffb61e"),
    "aspen" => ("#00936e", "#a4e2b4", "#e0f5e5", "#ffffff", "#fff8d1", "#ffec9f", "#ffd96a"),
    "human" => ("#4b3c39", "#ffffff", "#ffddca"),
    "stanford" => ("#ffffff", "#8c1515"),
)

    NA_SC[na] = ColorScheme([parse(Colorant, he) for he in he_])

end

include("../_include.jl")

@_include()

end
