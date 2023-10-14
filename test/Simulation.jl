using Random: seed!

using Test: @test

using BioLab

# ---- #

const REN = [-1.1507841949280184, -0.15170166555600342, -0.0]

# ---- #

const REP = reverse!(-REN)

# ---- #

const N = length(REN)

# ---- #

seed!(20230827)

# ---- #

@test BioLab.Simulation._mirror(N) == (REN, REP)

# ---- #

# 85.835 ns (2 allocations: 160 bytes)
@btime BioLab.Simulation._mirror($N);

# ---- #

const PO_ = sort!(rand(1000))

# ---- #

PO_ .-= minimum(PO_)

# ---- #

const NE_ = reverse!(-PO_)

# ---- #

for (ze, re) in ((false, vcat(view(NE_, 1:(length(NE_) - 1)), PO_)), (true, vcat(NE_, PO_)))

    @test BioLab.Simulation._concatenate(NE_, ze, PO_) == re

    # 591.614 ns (2 allocations: 23.69 KiB)
    # 585.966 ns (2 allocations: 23.69 KiB)
    @btime BioLab.Simulation._concatenate($NE_, $ze, $PO_)

end

# ---- #

for (ze, re) in ((false, vcat(view(REN, 1:(N - 1)), REP)), (true, vcat(REN, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror(N, ze) == re

    # 137.556 ns (4 allocations: 336 bytes)
    # 138.905 ns (4 allocations: 352 bytes)
    @btime BioLab.Simulation.make_vector_mirror($N, $ze)

end

# ---- #

for (ze, re) in ((false, vcat(view(REN, 1:(N - 1)) * 2, REP)), (true, vcat(REN * 2, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror_deep(N, ze) == re

    # 158.870 ns (5 allocations: 416 bytes)
    # 159.217 ns (5 allocations: 432 bytes)
    @btime BioLab.Simulation.make_vector_mirror_deep($N, $ze)

end

# ---- #

const RENW_ = [-1.1507841949280184, -0.651242930242011, -0.15170166555600342, -0.07585083277800171]

# ---- #

for (ze, re) in ((false, vcat(RENW_, REP)), (true, vcat(RENW_, -0.0, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror_wide(N, ze) == re

    # 157.088 ns (5 allocations: 464 bytes)
    # 157.670 ns (5 allocations: 480 bytes)
    @btime BioLab.Simulation.make_vector_mirror_wide($N, $ze)

end

# ---- #

const MA = [1 3 5; 2 4 6]

# ---- #

const N_RO, N_CO = size(MA)

# ---- #

for (ty, re) in ((Int, MA), (Float64, convert(Matrix{Float64}, MA)))

    @test BioLab.Simulation.make_matrix_1n(ty, N_RO, N_CO) == re

    # 121.271 ns (1 allocation: 112 bytes)
    # 144.646 ns (1 allocation: 112 bytes)
    @btime BioLab.Simulation.make_matrix_1n($ty, $N_RO, $N_CO)

end
