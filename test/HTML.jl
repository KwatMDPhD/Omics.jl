include("environment.jl")

# ---- #

id = "DIV_ID"

so_ = ("SOURCE_1", "SOURCE_2")

sc = "SCRIPT"

# ---- #

BioLab.HTML.make(id, so_, sc)

# ---- #

te = joinpath(tempdir(), "BioLab.test.HTML")

BioLab.Path.reset(te)

BioLab.HTML.make(id, so_, sc; ba = "#000000", ht = joinpath(te, "name.html"))
