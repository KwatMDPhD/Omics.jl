include("environment.jl")

# ---- #

te = joinpath(tempdir(), "BioLab.test.Network")

BioLab.Path.reset(te)

# ---- #

el_ = (
    Dict(
        "data" => Dict("id" => "A"),
        "position" => Dict("x" => 0, "y" => 0),
        "style" => Dict("background-color" => "#ff0000"),
    ),
    Dict(
        "data" => Dict("id" => "B"),
        "position" => Dict("x" => 20, "y" => 20),
        "style" => Dict("background-color" => "#00ff00"),
    ),
    Dict(
        "data" => Dict("id" => "C"),
        "position" => Dict("x" => 40, "y" => 40),
        "style" => Dict("background-color" => "#0000ff"),
    ),
    Dict(
        "data" => Dict("id" => "D"),
        "position" => Dict("x" => 80, "y" => 80),
        "style" => Dict("background-color" => "#f0f000"),
    ),
    Dict(
        "data" => Dict("id" => "E"),
        "position" => Dict("x" => 160, "y" => 160),
        "style" => Dict("background-color" => "#0f0f00"),
    ),
    Dict(
        "data" => Dict("id" => "F"),
        "position" => Dict("x" => 320, "y" => 320),
        "style" => Dict("background-color" => "#00f0f0"),
    ),
    Dict(
        "data" => Dict("id" => "G"),
        "position" => Dict("x" => 640, "y" => 640),
        "style" => Dict("background-color" => "#000f0f"),
    ),
    Dict(
        "data" => Dict("id" => "H", "source" => "F", "target" => "G"),
        "style" => Dict("line-color" => "#000000"),
    ),
)

BioLab.Network.plot(el_)

# ---- #

la = Dict("name" => "cose", "animate" => true)

ht = joinpath(te, "cose.html")

ex = "json"

js = joinpath(homedir(), "Downloads", "cose.json")

rm(js; force = true)

BioLab.Network.plot(el_; la, ex, ht)

# ---- #

if ispath(js)

    BioLab.Network.position!(el_[1:(end - 1)], js)

else

    println("Missing $js.")

end

BioLab.Network.plot(el_; la = Dict("name" => "preset"), ht = joinpath(te, "json_preset.html"))
