using Test: @test

using Nucleus

# ---- #

@test contains(
    Nucleus.Time.stamp(),
    r"^[\d]{4}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,2}_[\d]{1,3}$",
)

# ---- #

# 3.547 μs (73 allocations: 3.84 KiB)
#@btime Nucleus.Time.stamp();
