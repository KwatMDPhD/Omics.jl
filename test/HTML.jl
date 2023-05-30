include("environment.jl")

# ---- #

di = "DIV_ID"

so_ = ("SOURCE1", "SOURCE2")

sc = "SCRIPT"

# ---- #

BioLab.HTML.write(di, so_, sc)

# ---- #

te = joinpath(tempdir(), "BioLab.test.HTML")

BioLab.Path.reset(te)

BioLab.HTML.write(di, so_, sc; ht = joinpath(te, "name.html"))
