using Test: @test

using Omics

# ---- #

const E1_ = Dict{String, Any}[
    Dict("data" => Dict("id" => "A"), "position" => Dict("y" => 0, "x" => 0)),
    Dict("data" => Dict("id" => "B"), "position" => Dict("y" => 20, "x" => 20)),
    Dict("data" => Dict("id" => "C"), "position" => Dict("y" => 40, "x" => 40)),
    Dict("data" => Dict("id" => "D"), "position" => Dict("y" => 80, "x" => 80)),
    Dict("data" => Dict("id" => "E"), "position" => Dict("y" => 160, "x" => 160)),
    Dict("data" => Dict("id" => "F"), "position" => Dict("y" => 320, "x" => 320)),
    Dict("data" => Dict("id" => "G"), "position" => Dict("y" => 640, "x" => 640)),
    Dict("data" => Dict("id" => "H"), "position" => Dict("y" => 800, "x" => 800)),
    Dict("data" => Dict("id" => "I"), "position" => Dict("y" => 1000, "x" => 1000)),
    Dict("data" => Dict("id" => "J", "source" => "H", "target" => "I")),
]

# ---- #

Omics.Cytoscape.plot("", E1_)

# ---- #

Omics.Path.ope(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "1.html"),
        E1_,
        "png";
        st_ = map(
            id -> Dict(
                "selector" => "#$(Omics.Cytoscape._identify(E1_[id]))",
                "style" => Dict("background-color" => Omics.Coloring.I2_[id]),
            ),
            eachindex(E1_),
        ),
        la = Dict("name" => "preset"),
        co = "#000000",
        sc = 2.0,
    ),
)

# ---- #

const E2_ = Omics.Cytoscape.rea(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "2.html"),
        E1_,
        "json";
        la = Dict("name" => "cose"),
    ),
)

Omics.Cytoscape.position!(E1_, E2_)

@test Omics.Cytoscape.rea(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "3.html"),
        E1_,
        "json";
        la = Dict("name" => "preset"),
    ),
) == E2_
