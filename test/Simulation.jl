using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: seed!

# ---- #

const SE = 20230827

const UP = 3

const NE_ = [-1.1507841949280184, -0.15170166555600342, -0.0]

const PO_ = [0.0, 0.15170166555600342, 1.1507841949280184]

# ---- #

seed!(SE)

@test Omics.Simulation._mirror(lastindex(PO_)) == (NE_, PO_)

# ---- #

for (ze, re) in ((false, vcat(NE_[1:(end - 1)], PO_)), (true, vcat(NE_, PO_)))

    @test Omics.Simulation._concatenate(NE_, ze, PO_) == re

end

# ---- #

for (ze, re) in ((false, vcat(NE_[1:(end - 1)], PO_)), (true, vcat(NE_, PO_)))

    seed!(SE)

    @test Omics.Simulation.make_vector_mirror(UP, ze) == re

end

# ---- #

const N2_ = NE_ * 2

for (ze, re) in ((false, vcat(N2_[1:(end - 1)], PO_)), (true, vcat(N2_, PO_)))

    seed!(SE)

    @test Omics.Simulation.make_vector_mirror_deep(UP, ze) == re

end

# ---- #

const RW_ =
    [-1.1507841949280184, -0.651242930242011, -0.15170166555600342, -0.07585083277800171]

for (ze, re) in ((false, vcat(RW_, PO_)), (true, vcat(RW_, -0.0, PO_)))

    seed!(SE)

    @test Omics.Simulation.make_vector_mirror_wide(UP, ze) == re

end

# ---- #

const MA = [1 3 5; 2 4 6]

const UR, UC = size(MA)

for (ty, re) in ((Int, MA), (Float64, convert(Matrix{Float64}, MA)))

    @test Omics.Simulation.make_matrix_1n(ty, UR, UC) == re

end

# ---- #

@test Omics.Simulation.label(2, "Sample") == ["Sample 1", "Sample 2"]
