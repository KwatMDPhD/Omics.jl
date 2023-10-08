using Test: @test

using BioLab

# ---- #

@test contains(
    BioLab.Time.stamp(),
    r"^[\d]{4}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,3}$",
)

# ---- #

# 3.401 μs (73 allocations: 3.84 KiB)
@btime BioLab.Time.stamp();
