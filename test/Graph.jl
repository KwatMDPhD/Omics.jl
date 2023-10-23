using Test: @test

using Nucleus

# ---- #

const EL_ = Dict{String, Any}[
    Dict(
        "data" => Dict("id" => "A"),
        "position" => Dict("y" => 0, "x" => 0),
        "style" => Dict("background-color" => "#790505"),
    ),
    Dict(
        "data" => Dict("id" => "B"),
        "position" => Dict("y" => 20, "x" => 20),
        "style" => Dict("background-color" => "#a40522"),
    ),
    Dict(
        "data" => Dict("id" => "C"),
        "position" => Dict("y" => 40, "x" => 40),
        "style" => Dict("background-color" => "#e06351"),
    ),
    Dict(
        "data" => Dict("id" => "D"),
        "position" => Dict("y" => 80, "x" => 80),
        "style" => Dict("background-color" => "#dd9159"),
    ),
    Dict(
        "data" => Dict("id" => "E"),
        "position" => Dict("y" => 160, "x" => 160),
        "style" => Dict("background-color" => "#fc7f31"),
    ),
    Dict(
        "data" => Dict("id" => "F"),
        "position" => Dict("y" => 320, "x" => 320),
        "style" => Dict("background-color" => "#fbb92d"),
    ),
    Dict(
        "data" => Dict("id" => "G"),
        "position" => Dict("y" => 640, "x" => 640),
        "style" => Dict("background-color" => "#561649"),
    ),
    Dict(
        "data" => Dict("id" => "H", "source" => "F", "target" => "G"),
        "style" => Dict("line-color" => "#6c9956"),
    ),
]

# ---- #

const DW = joinpath(homedir(), "Downloads")

# ---- #

const NAME1 = "preset"

# ---- #

const HT1 = joinpath(Nucleus.TE, "$NAME1.html")

# ---- #

const EX1 = "png"

# ---- #

Nucleus.Graph.plot(HT1, EL_; la = Dict("name" => NAME1), ex = EX1)

# ---- #

@test isfile(HT1)

# ---- #

@test isfile(joinpath(Nucleus.TE, "$NAME1.$EX1"))

# ---- #

const NAME2 = "cose"

# ---- #

const HT2 = joinpath(Nucleus.TE, "$NAME2.html")

# ---- #

const EX2 = "json"

# ---- #

Nucleus.Graph.plot(HT2, EL_; la = Dict("name" => NAME2), ex = EX2)

# ---- #

@test isfile(HT2)

# ---- #

const EL2_ = Nucleus.Graph.read(joinpath(Nucleus.TE, "$NAME2.$EX2"))

# ---- #

@test lastindex(EL_) === lastindex(EL2_)

# ---- #

function is_equal(el1_, el2_, ke_ = ("data",))

    all(all(el1[ke] == el2[ke] for ke in ke_) for (el1, el2) in zip(el1_, el2_))

end

# ---- #

@test is_equal(EL_, EL2_)

# ---- #

Nucleus.Graph.position!(EL_, EL2_)

# ---- #

@test is_equal(EL_, EL2_, ("data", "position"))

# ---- #

const NAME3 = "cose_preset"

# ---- #

const HT3 = joinpath(Nucleus.TE, "$NAME3.html")

# ---- #

const EX3 = "json"

# ---- #

Nucleus.Graph.plot(HT3, EL_; la = Dict("name" => "preset"), ex = EX3)

# ---- #

@test isfile(HT3)

# ---- #

@test EL2_ == Nucleus.Graph.read(joinpath(Nucleus.TE, "$NAME3.$EX3"))
