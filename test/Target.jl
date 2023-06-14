using StatsBase: mean

include("environment.jl")

# ---- #

nu_ = [2, 3, 4, 5]

# ---- #

co_ = [0, 0, 1, 1]

@test BioLab.Target._aim(co_, nu_) == (co_, nu_)

# ---- #

bo_ = convert(Vector{Bool}, co_)

@test BioLab.Target._aim(bo_, nu_) == ([2, 3], [4, 5])

# ---- #

function fu(nu1_, nu2_)

    sum(nu1_) - sum(nu2_)

end

# ---- #

n_co = 4

nu_ = [10^(id - 1) for id in 1:n_co]

# ---- #

co_ = nu_ .+ 1

@test BioLab.Target._trigger(fu, co_, nu_) == 4

# ---- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

@test BioLab.Target._trigger(fu, bo_, nu_) == -1089

# ---- #

function fu(nu1_, nu2_)

    mean(nu1_) - mean(nu2_)

end

# ---- #

n_ro = 2

n_co = 6

ma = Matrix(reshape(1.0:(n_ro * n_co), (n_ro, n_co)))

# ---- #

co_ = [10^(id - 1) for id in 1:n_co]

@test BioLab.Target.target(fu, co_, ma) == [18512.5, 18511.5]

# 43.603 ns (1 allocation: 80 bytes) 
# @btime BioLab.Target.target($fu, $co_, $ma);

# ---- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

@test BioLab.Target.target(fu, bo_, ma) == [-6.0, -6]

# 180.978 ns (7 allocations: 528 bytes) 
# @btime BioLab.Target.target($fu, $bo_, $ma);
