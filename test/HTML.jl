include("environment.jl")

# ---- #

id = "DIV_ID"

so_ = ("SOURCE_1", "SOURCE_2")

sc = "SCRIPT"

# ---- #

BioLab.HTML.make("", id, so_, sc)

# ---- #

ht = joinpath(TE, "name.html")

for ba in ("#000000", "#ffffff")

    BioLab.HTML.make(ht, id, so_, sc; ba)

end
