using StatsBase

include("environment.jl")

# ---- #

nu_ = [2, 3, 4, 5]

# ---- #

co_ = [0, 0, 1, 1]

@test BioLab.FeatureXSample._aim(co_, nu_) == (co_, nu_)

# ---- #

bo_ = convert(Vector{Bool}, co_)

BioLab.print_header(bo_)

@test BioLab.FeatureXSample._aim(bo_, nu_) == ([2, 3], [4, 5])

# @btime BioLab.FeatureXSample._aim($bo_, $nu_)

# ---- #

function fu(nu1_, nu2_)

    sum(nu1_) - sum(nu2_)

end

# ---- #

n_co = 4

nu_ = [10^(id - 1) for id in 1:n_co]

# ---- #

co_ = [co + 1 for co in nu_]

@test BioLab.FeatureXSample._trigger(fu, co_, nu_) == 4

# ---- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

BioLab.print_header(bo_)

@test BioLab.FeatureXSample._trigger(fu, bo_, nu_) == -1089

# @btime BioLab.FeatureXSample._trigger($fu, $bo_, $nu_)

# ---- #

n_ro = 2

n_co = 6

fe_x_sa_x_nu = reshape(1.0:(n_ro * n_co), (n_ro, n_co))

# ---- #

fut = (nu1_, nu2_) -> mean(nu1_) - mean(nu2_)

co_ = [10^(id - 1) for id in 1:n_co]

@test BioLab.FeatureXSample.target(fut, co_, fe_x_sa_x_nu) == [18512.5, 18511.5]

# @btime BioLab.FeatureXSample.target($fut, $co_, $fe_x_sa_x_nu)

# ---- #

n_ze = div(n_co, 2)

bo_ = vcat(fill(false, n_ze), fill(true, n_co - n_ze))

@test BioLab.FeatureXSample.target(fut, bo_, fe_x_sa_x_nu) == [-6.0, -6]

# @btime BioLab.FeatureXSample.target($fut, $bo_, $fe_x_sa_x_nu)
