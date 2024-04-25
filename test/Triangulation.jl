using Test: @test

using Nucleus

# ---- #

using DelaunayTriangulation: triangulate

# ---- #

const CA = [
    -1.0 -1 1 1
    1 -1 -1 1
]

# ---- #

const TR = triangulate(eachcol(CA))

# ---- #

# TODO: Test.
const VP = Nucleus.Triangulation.bound(TR)

# ---- #

# 339.450 ns (6 allocations: 1.28 KiB)
#@btime Nucleus.Triangulation.bound(TR);

# ---- #

for yx in eachcol(CA)

    @test Nucleus.Triangulation.is_in(yx, VP)

    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Triangulation.is_in($yx, VP)

end
