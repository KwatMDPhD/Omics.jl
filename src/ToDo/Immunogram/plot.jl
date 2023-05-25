include("_.jl")

# ---- #

theta = [
    "The Complement System",
    "Hematopoiesis",
    "Transmigration",
    "Antigen Recognition",
    "Self Tolerance",
    "Innate Response",
    "Antigen Presentation",
    "Adaptive Response",
    "Clonal Selection",
    "Cytotoxic Response",
    "Humoral Response",
    "Memory",
]

BioLab.Plot.plot_radar(
    (theta,),
    ([8, 8, 7, 10, 6, 8, 8, 8, 8, 8, 8, 8],);
    radialaxis_range = (0, 10),
    line_color_ = ("#f47983",),
    fillcolor_ = ("#fcc9b9",),
    layout = Dict("title" => Dict("text" => "Person 1")),
)


BioLab.Plot.plot_radar(
    (theta,),
    ([6, 8, 8, 8, 8, 8, 8, 6, 6, 8, 6, 8],);
    radialaxis_range = (0, 10),
    line_color_ = ("#f47983",),
    fillcolor_ = ("#fcc9b9",),
    layout = Dict("title" => Dict("text" => "Person 2")),
)
