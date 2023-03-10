using StatsBase

include("_.jl")

# --------------------------------------------- #

nu_ = [2, 3, 4, 5]

# --------------------------------------------- #

co_ = [0, 0, 1, 1]

BioLab.print_header(co_)

@test BioLab.FeatureXSample._aim(co_, nu_) == (co_, nu_)

# @code_warntype BioLab.FeatureXSample._aim(co_, nu_)

# 2.125 ns (0 allocations: 0 bytes)
# @btime BioLab.FeatureXSample._aim($co_, $nu_)

# --------------------------------------------- #

bo_ = convert(Vector{Bool}, co_)

BioLab.print_header(bo_)

@test BioLab.FeatureXSample._aim(bo_, nu_) == ([2, 3], [4, 5])

# @code_warntype BioLab.FeatureXSample._aim(bo_, nu_)

# 116.703 ns (3 allocations: 224 bytes)
# @btime BioLab.FeatureXSample._aim($bo_, $nu_)

# --------------------------------------------- #

function fu(nu1_, nu2_)

    sum(nu1_) - sum(nu2_)

end

# --------------------------------------------- #

n_co = 4

nu_ = [10^(id - 1) for id in 1:n_co]

# --------------------------------------------- #

co_ = [co + 1 for co in nu_]

BioLab.print_header(co_)

@test BioLab.FeatureXSample._trigger(fu, co_, nu_) == 4

# @code_warntype BioLab.FeatureXSample._trigger(fu, co_, nu_)

# 4.875 ns (0 allocations: 0 bytes)
# @btime BioLab.FeatureXSample._trigger($fu, $co_, $nu_)

# --------------------------------------------- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

BioLab.print_header(bo_)

@test BioLab.FeatureXSample._trigger(fu, bo_, nu_) == -1089

# @code_warntype BioLab.FeatureXSample._trigger(fu, bo_, nu_)

# 112.206 ns (3 allocations: 224 bytes)
# @btime BioLab.FeatureXSample._trigger($fu, $bo_, $nu_)

# --------------------------------------------- #

n_ro = 2

n_co = 6

fe_x_sa_x_nu = BioLab.Matrix.simulate(n_ro, n_co, "1.0:")

display(fe_x_sa_x_nu)

fut = (nu1_, nu2_) -> mean(nu1_) - mean(nu2_)

co_ = [10^(id - 1) for id in 1:n_co]

BioLab.print_header(co_)

@test BioLab.FeatureXSample.target(fut, co_, fe_x_sa_x_nu) == [18512.5, 18511.5]

# @code_warntype BioLab.FeatureXSample.target(fut, co_, fe_x_sa_x_nu)

# 74.373 ns (1 allocation: 80 bytes)
# @btime BioLab.FeatureXSample.target($fut, $co_, $fe_x_sa_x_nu)

# --------------------------------------------- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

BioLab.print_header(bo_)

@test BioLab.FeatureXSample.target(fut, bo_, fe_x_sa_x_nu) == [-6.0, -6]

# @code_warntype BioLab.FeatureXSample.target(fut, bo_, fe_x_sa_x_nu)

# 268.059 ns (7 allocations: 528 bytes)
# @btime BioLab.FeatureXSample.target($fut, $bo_, $fe_x_sa_x_nu)
