using Random: seed!

using Test: @test

using BioLab

# ---- #

const REN = [-1.1507841949280184, -0.15170166555600342, -0.0]

# ---- #

const REP = reverse!(-REN)

# ---- #

const N = lastindex(REN)

# ---- #

seed!(20230827)

# ---- #

@test BioLab.Simulation._mirror(N) == (REN, REP)

# ---- #

# 85.753 ns (2 allocations: 160 bytes)
#@btime BioLab.Simulation._mirror(N);

# ---- #

const NC = 1000

# ---- #

const PO_ = sort!(rand(NC))

# ---- #

PO_ .-= minimum(PO_)

# ---- #

const NE_ = reverse!(-PO_)

# ---- #

for (ze, re) in ((false, vcat(view(NE_, 1:(NC - 1)), PO_)), (true, vcat(NE_, PO_)))

    @test BioLab.Simulation._concatenate(NE_, ze, PO_) == re

    # 552.419 ns (2 allocations: 23.69 KiB)
    # 537.500 ns (2 allocations: 23.69 KiB)
    #@btime BioLab.Simulation._concatenate(NE_, $ze, PO_)

end

# ---- #

for (ze, re) in ((false, vcat(view(REN, 1:(N - 1)), REP)), (true, vcat(REN, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror(N, ze) == re

    # 136.120 ns (4 allocations: 336 bytes)
    # 135.816 ns (4 allocations: 352 bytes)
    #@btime BioLab.Simulation.make_vector_mirror(N, $ze)

end

# ---- #

const REND = 2REN

# ---- #

for (ze, re) in ((false, vcat(view(REND, 1:(N - 1)), REP)), (true, vcat(REND, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror_deep(N, ze) == re

    # 156.134 ns (5 allocations: 416 bytes)
    # 156.595 ns (5 allocations: 432 bytes)
    #@btime BioLab.Simulation.make_vector_mirror_deep(N, $ze)

end

# ---- #

const RENW_ = [-1.1507841949280184, -0.651242930242011, -0.15170166555600342, -0.07585083277800171]

# ---- #

for (ze, re) in ((false, vcat(RENW_, REP)), (true, vcat(RENW_, -0.0, REP)))

    seed!(20230827)

    @test BioLab.Simulation.make_vector_mirror_wide(N, ze) == re

    # 154.147 ns (5 allocations: 464 bytes)
    # 154.191 ns (5 allocations: 480 bytes)
    #@btime BioLab.Simulation.make_vector_mirror_wide(N, $ze)

end

# ---- #

const MA = [1 3 5; 2 4 6]

# ---- #

const N_RO, N_CO = size(MA)

# ---- #

for (ty, re) in ((Int, MA), (Float64, convert(Matrix{Float64}, MA)))

    @test BioLab.Simulation.make_matrix_1n(ty, N_RO, N_CO) == re

    # 88.802 ns (1 allocation: 112 bytes)
    # 88.363 ns (1 allocation: 112 bytes)
    #@btime BioLab.Simulation.make_matrix_1n($ty, N_RO, N_CO)

end
