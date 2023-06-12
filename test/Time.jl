include("environment.jl")

# ---- #

st = BioLab.Time.stamp()

@test contains(st, r"^[\d]{4}\.[\d]{1}\.[\d]{2}_[\d]{2}\.[\d]{2}\.[\d]{2}\.[\d]{3}$")
