include("_.jl")

# --------------------------------------------- #

di = "DIV_ID"

so_ = ("SOURCE1", "SOURCE2")

sc = "SCRIPT"

te = joinpath(tempdir(), "BioLab.test.HTML")

BioLab.Path.empty(te)

ht = joinpath(te, "name.html")

display(displayable("html"))

BioLab.HTML.write(di, so_, sc; ht)

jl = """
display(displayable("html"))

using BioLab

BioLab.HTML.write("$di", $so_, "$sc")
"""

run(`julia --project --eval $jl`)

# @code_warntype BioLab.HTML.write(di, so_, sc)
