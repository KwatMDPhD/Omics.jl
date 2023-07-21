using Test: @test

using BioLab

# ---- #

st = BioLab.Time.stamp()

@test contains(st, r"^[\d]{4}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,3}$")
