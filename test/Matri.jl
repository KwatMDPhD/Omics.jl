using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: randstring, seed!

using StatsBase: mean

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

# ---- #

for (ro_, r2_, m2) in (
    (
        ["Row 1", "Row 1", "Row 2"],
        ["Row 1", "Row 2"],
        [
            5.5 11
            100 200
        ],
    ),
    (["Row 1", "Row 1", "Row 1"], ["Row 1"], [37.0 74]),
)

    @test Omics.Matri.collapse(mean, Float64, ro_, MA) == (r2_, m2)

end

# ---- #

# 24.041 μs (408 allocations: 126.67 KiB)
# 2.698 ms (2708 allocations: 11.93 MiB)
# 602.521 ms (3466 allocations: 815.53 MiB)
# 2.561 s (3799 allocations: 3.08 GiB)
for ur in (100, 1000, 10000, 20000)

    seed!(20230920)

    #disable_logging(Info)
    #@btime Omics.Matri.collapse(
    #    mean,
    #    Float64,
    #    $([randstring(('A', 'B', 'C', 'D', 'E', 'F', 'G'), 3) for _ in 1:ur]),
    #    $(rand(ur, ur)),
    #)
    #disable_logging(Debug)

end

# ---- #

# TODO
Omics.Matri.joi
