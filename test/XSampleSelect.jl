using Test: @test

using Omics

# ---- #

Omics.XSampleSelect.index

# ---- #

Omics.XSampleSelect.select

# ---- #

Omics.XSampleSelect.select

# ---- #

# 15.708 μs (22 allocations: 2.03 KiB)

for (vt_, vf, mi, re) in (([1, 2, 1, 2], rand(1000, 4), 1.0, trues(1000)),)

    @test Omics.XSampleSelect.select(vt_, vf, mi) == re

    @btime Omics.XSampleSelect.select($vt_, $vf, $mi)

end
