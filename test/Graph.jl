using Test: @test

using BioLab

# ---- #

const EL_ = Vector{Dict{String, Any}}([
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

# ---- #

const DW = joinpath(homedir(), "Downloads")

# ---- #

const NAME1 = "preset"

const EX1 = "png"

BioLab.Graph.plot(joinpath(BioLab.TE, "$NAME1.html"), EL_; la = Dict("name" => NAME1), ex = EX1)

const FI1 = joinpath(DW, "$NAME1.$EX1")

# ---- #

const NAME2 = "cose"

const EX2 = "json"

BioLab.Graph.plot(joinpath(BioLab.TE, "$NAME2.html"), EL_; la = Dict("name" => NAME2), ex = EX2)

const FI2 = joinpath(DW, "$NAME2.$EX2")

# ---- #

function read_element(js)

    ty_el_ = BioLab.Dict.read(js)["elements"]

    vcat(ty_el_["nodes"], ty_el_["edges"])

end

# ---- #

const EL2_ = read_element(FI2)

# ---- #

BioLab.Graph.position!(EL_, EL2_)

# ---- #

const NAME3 = "cose_preset"

const EX3 = "json"

BioLab.Graph.plot(joinpath(BioLab.TE, "$NAME3.html"), EL_; la = Dict("name" => "preset"), ex = EX3)

const FI3 = joinpath(DW, "$NAME3.$EX3")

@test EL2_ == read_element(FI3)

# ---- #

foreach(rm, (FI1, FI2, FI3))
