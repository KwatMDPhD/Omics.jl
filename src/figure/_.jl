module figure

using DataFrames

using JSON3

using ..OnePiece

# TODO: Use the categorical colorscale

include("../_include_neighbor.jl")

_include_neighbor(@__FILE__)

#from plotly.colors import make_colorscale, qualitative, sequential
#
#{
#    "Plotly": make_colorscale(qualitative.Plotly),
#    "Plotly3": make_colorscale(sequential.Plotly3),
#    "binary": make_colorscale(["#006442", "#ffffff", "#ffb61e"]),
#    "human": make_colorscale(["#4b3c39", "#ffffff", "#ffddca"]),
#    "stanford": make_colorscale(["#ffffff", "#8c1515"]),
#}
NAME_COLORSCALE = Dict(
    "Plasma" => [
        [0.0, "#0d0887"],
        [0.1111111111111111, "#46039f"],
        [0.2222222222222222, "#7201a8"],
        [0.3333333333333333, "#9c179e"],
        [0.4444444444444444, "#bd3786"],
        [0.5555555555555556, "#d8576b"],
        [0.6666666666666666, "#ed7953"],
        [0.7777777777777777, "#fb9f3a"],
        [0.8888888888888888, "#fdca26"],
        [1.0, "#f0f921"],
    ],
    "Plotly3" => [
        [0.0, "#0508b8"],
        [0.08333333333333333, "#1910d8"],
        [0.16666666666666666, "#3c19f0"],
        [0.25, "#6b1cfb"],
        [0.3333333333333333, "#981cfd"],
        [0.41666666666666663, "#bf1cfd"],
        [0.5, "#dd2bfd"],
        [0.5833333333333333, "#f246fe"],
        [0.6666666666666666, "#fc67fd"],
        [0.75, "#fe88fc"],
        [0.8333333333333333, "#fea5fd"],
        [0.9166666666666666, "#febefe"],
        [1.0, "#fec3fe"],
    ],
    "Plotly" => [
        [0.0, "#636EFA"],
        [0.1111111111111111, "#EF553B"],
        [0.2222222222222222, "#00CC96"],
        [0.3333333333333333, "#AB63FA"],
        [0.4444444444444444, "#FFA15A"],
        [0.5555555555555556, "#19D3F3"],
        [0.6666666666666666, "#FF6692"],
        [0.7777777777777777, "#B6E880"],
        [0.8888888888888888, "#FF97FF"],
        [1.0, "#FECB52"],
    ],
    "binary" => [[0.0, "#006442"], [0.5, "#ffffff"], [1.0, "#ffb61e"]],
    "human" => [[0.0, "#4b3c39"], [0.5, "#ffffff"], [1.0, "#ffddca"]],
    "stanford" => [[0.0, "#ffffff"], [1.0, "#8c1515"]],
)

end
