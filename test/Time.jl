using Test: @test

# ---- #

st = BioLab.Time.stamp()

@test contains(st, r"^[\d]{4}_[\d]{1}_[\d]{2}_[\d]{2}_[\d]{2}_[\d]{2}_[\d]{3}$")
