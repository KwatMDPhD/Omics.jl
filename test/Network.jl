using Test: @test

using BioLab

# ---- #

dw = joinpath(homedir(), "Downloads")

# ---- #

el_ = Vector{Dict{String, Any}}([
    Dict(
        "data" => Dict("id" => "A"),
        "position" => Dict("x" => 0, "y" => 0),
        "style" => Dict("background-color" => "#790505"),
    ),
    Dict(
        "data" => Dict("id" => "B"),
        "position" => Dict("x" => 20, "y" => 20),
        "style" => Dict("background-color" => "#a40522"),
    ),
    Dict(
        "data" => Dict("id" => "C"),
        "position" => Dict("x" => 40, "y" => 40),
        "style" => Dict("background-color" => "#e06351"),
    ),
    Dict(
        "data" => Dict("id" => "D"),
        "position" => Dict("x" => 80, "y" => 80),
        "style" => Dict("background-color" => "#dd9159"),
    ),
    Dict(
        "data" => Dict("id" => "E"),
        "position" => Dict("x" => 160, "y" => 160),
        "style" => Dict("background-color" => "#fc7f31"),
    ),
    Dict(
        "data" => Dict("id" => "F"),
        "position" => Dict("x" => 320, "y" => 320),
        "style" => Dict("background-color" => "#fbb92d"),
    ),
    Dict(
        "data" => Dict("id" => "H", "source" => "F", "target" => "G"),
        "style" => Dict("line-color" => "#6c9956"),
    ),
    Dict(
        "data" => Dict("id" => "G"),
        "position" => Dict("x" => 640, "y" => 640),
        "style" => Dict("background-color" => "#561649"),
    ),
])

pr1 = "preset"

ex1 = "png"

# TODO: Understand why zooming changes the colors.
# TODO: Understand why colors do not show up in HTML but in PNG.
BioLab.Network.plot(joinpath(TE, "$pr1.html"), el_; la = Dict("name" => pr1), ex = ex1)

fi1 = joinpath(dw, "$pr1.$ex1")

# ---- #

pr2 = "cose"

ex2 = "json"

# TODO: Understand why zooming changes the colors.
BioLab.Network.plot(joinpath(TE, "$pr2.html"), el_; la = Dict("name" => pr2), ex = ex2)

fi2 = joinpath(dw, "$pr2.$ex2")

# ---- #

function read_element(js)

    ty_el_ = BioLab.Dict.read(js)["elements"]

    vcat(ty_el_["nodes"], ty_el_["edges"])

end

# ---- #

no1_ = read_element(fi2)

BioLab.Network.position!(el_, no1_)

# ---- #

pr3 = "cose_preset"

ex3 = "json"

BioLab.Network.plot(joinpath(TE, "$pr3.html"), el_; la = Dict("name" => "preset"), ex = ex3)

fi3 = joinpath(dw, "$pr3.$ex3")

@test no1_ == read_element(fi3)

# ---- #

for fi in (fi1, fi2, fi3)

    rm(fi)

end
