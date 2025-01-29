using Test: @test

using Omics

# ---- #

const EL_ = Dict{String, Any}[
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

const ST_ = map(
    id -> Dict(
        "selector" => "#$(EL_[id]["data"]["id"])",
        "style" => Dict("background-color" => Omics.Palette.HE_[id]),
    ),
    eachindex('a':'i'),
)

# ---- #

@test isfile(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "1.html"),
        EL_;
        st_ = ST_,
        la = Dict("name" => "preset"),
        ex = "png",
    ),
)

# ---- #

function test_element(e1_, e2_, ke_)

    @test all(id -> all(ke -> e1_[id][ke] == e2_[id][ke], ke_), eachindex(e1_))

end

# ---- #

const E2_ = Omics.Cytoscape.rea(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "2.html"),
        EL_;
        la = Dict("name" => "cose"),
        ex = "json",
    ),
)

test_element(EL_, E2_, ("data",))

# ---- #

Omics.Cytoscape.position!(EL_, E2_)

test_element(EL_, E2_, ("data", "position"))

# ---- #

@test Omics.Cytoscape.rea(
    Omics.Cytoscape.plot(
        joinpath(tempdir(), "3.html"),
        EL_;
        st_ = ST_,
        la = Dict("name" => "preset"),
        ex = "json",
    ),
) == E2_
