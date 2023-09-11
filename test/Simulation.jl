using Random: seed!

using Test: @test

using BioLab

# ---- #

function seed2!()

    seed!(20230610)

end

# ---- #

const REN = [-1.4897554994413376, -0.370149968439238, -0.0]

const REP = -reverse((REN))

# ---- #

const N = length(REN)

seed2!()

const NE_, PO_ = BioLab.Simulation._mirror(N)

@test NE_ == REN

@test PO_ == REP

# ---- #

const REN0P = vcat(view(REN, 1:(N - 1)), REP)

const REN00P = vcat(REN, REP)

for (ze, re) in ((false, REN0P), (true, REN00P))

    @test BioLab.Simulation._concatenate(NE_, ze, PO_) == re

    seed2!()

    @test BioLab.Simulation.make_vector_mirror(N, ze) == re

end

# ---- #

for (ze, re) in ((false, vcat(REN[1:(end - 1)] * 2, REP)), (true, vcat(REN * 2, REP)))

    seed2!()

    @test BioLab.Simulation.make_vector_mirror_deep(N, ze) == re

end

# ---- #

const RENW_ = [-1.4897554994413376, -0.9299527339402878, -0.370149968439238, -0.185074984219619]

for (ze, re) in ((false, vcat(RENW_, REP)), (true, vcat(RENW_, -0.0, REP)))

    seed2!()

    @test BioLab.Simulation.make_vector_mirror_wide(N, ze) == re

end

# ---- #

const MA = [1 3 5; 2 4 6]

const N_RO, N_CO = size(MA)

for (ty, re) in ((Int, MA), (Float64, convert(Matrix{Float64}, MA)))

    @test BioLab.Simulation.make_matrix_1n(ty, N_RO, N_CO) == re

end
