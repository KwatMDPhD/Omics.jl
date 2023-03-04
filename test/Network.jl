include("_.jl")

te = BioLab.Path.make_temporary("BioLab.test.Network")

el_ = (
    Dict(
        "data" => Dict("id" => "V1"),
        "style" => Dict("background-color" => "red"),
        "position" => Dict("x" => 0, "y" => 0),
    ),
    Dict(
        "data" => Dict("id" => "V2"),
        "style" => Dict("background-color" => "yellow"),
        "position" => Dict("x" => 100, "y" => 0),
    ),
    Dict(
        "data" => Dict("id" => "V3"),
        "style" => Dict("background-color" => "green"),
        "position" => Dict("x" => 100, "y" => 100),
    ),
    Dict(
        "data" => Dict("id" => "V4"),
        "style" => Dict("background-color" => "blue"),
        "position" => Dict("x" => 0, "y" => 100),
    ),
    Dict(
        "data" => Dict("id" => "V1_V2", "source" => "V1", "target" => "V2"),
        "style" => Dict("line-color" => "purple"),
    ),
)

BioLab.Network.plot(el_)

la = Dict("name" => "cose", "animate" => false)

ht = joinpath(te, "cose.html")

wr = "json"

BioLab.Network.plot(el_; la, ht, wr)

# @code_warntype BioLab.Network.plot(el_; la, ht, wr)

js = joinpath(homedir(), "Downloads", "cose.json")

if ispath(js)

    BioLab.Network.position!(el_[1:(end - 1)], js)

    # @code_warntype BioLab.Network.position!(el_[1:(end - 1)], js)

else

    println("🫥 $js is missing.")

end

BioLab.Network.plot(el_; la = Dict("name" => "preset"), ht = joinpath(te, "json_preset.html"))
