include("environment.jl")

# ---- #

id = "DIV_ID"

so_ = ("SOURCE_1", "SOURCE_2")

sc = "SCRIPT"

# ---- #

BioLab.HTML.write(id, so_, sc)

# ---- #

te = joinpath(tempdir(), "BioLab.test.HTML")

BioLab.Path.reset(te)

BioLab.HTML.write(id, so_, sc; ht = joinpath(te, "name.html"))
