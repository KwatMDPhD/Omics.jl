using Test: @test

using Omics

# ---- #

Omics.XSampleSelect.index

# ---- #

# 179.255 ns (6 allocations: 400 bytes)

for (ro_, se_, re) in ((
    ["_1", "_2", "_3", "aa", "bb", "cc", "_7", "_8", "_9"],
    ["aa", "bb", "cc"],
    [0, 0, 0, 1, 1, 1, 0, 0, 0],
),)

    @test Omics.XSampleSelect.select(ro_, nothing, se_) == re

    #@btime Omics.XSampleSelect.select($ro_, nothing, $se_)

end

# ---- #

Omics.XSampleSelect.select

# ---- #

# 15.708 μs (22 allocations: 2.03 KiB)

for (vt_, vf, mi, re) in (([1, 2, 1, 2], rand(1000, 4), 1.0, trues(1000)),)

    @test Omics.XSampleSelect.select(vt_, vf, mi) == re

    #@btime Omics.XSampleSelect.select($vt_, $vf, $mi)

end
