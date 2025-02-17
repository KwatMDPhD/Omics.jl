using Test: @test

using Omics

# ---- #

for (n1_, n2_, re) in ()

    Omics.Difference.get_mean_difference

end

# ---- #

for (nu_, re) in ()

    Omics.Difference.get_standard_deviation

end

# ---- #

# 16.073 ns (0 allocations: 0 bytes)
# 16.533 ns (0 allocations: 0 bytes)
# 16.366 ns (0 allocations: 0 bytes)
# 16.241 ns (0 allocations: 0 bytes)

for (n1_, n2_, re) in (
    (ones(Int, 3), fill(0.001, 3), -4.990009990009989),
    (collect(1:3), collect(10:10:30), 1.6363636363636365),
    (fill(0.001, 3), ones(Int, 3), 4.990009990009989),
    (fill(0.001, 3), fill(10, 3), 4.999000099990002),
)

    @test Omics.Difference.get_signal_to_noise_ratio(n1_, n2_) === re

    #@btime Omics.Difference.get_signal_to_noise_ratio($n1_, $n2_)

end

# ---- #

for (n1_, n2_, re) in ()

    Omics.Difference.get_log_ratio

end
