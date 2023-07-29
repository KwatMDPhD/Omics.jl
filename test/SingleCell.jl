using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "SingleCell")

# ---- #

@test readdir(DA) == ["7166_mr_87_filtered", "7166_mr_96_filtered"]

# ---- #

const SA_DI = Dict(
    sa => joinpath(DA, di) for
    (sa, di) in (("Sample 96", "7166_mr_96_filtered"), ("Sample 87", "7166_mr_87_filtered"))
)

const FE_, BA_, FE_X_BA_X_CO, SA_ = BioLab.SingleCell.read(SA_DI)

const N_FE = 56858

const N_BA = 5158

@test length(FE_) == N_FE

@test length(BA_) == N_BA

@test size(FE_X_BA_X_CO) == (N_FE, N_BA)

@test length(SA_) == N_BA

# ---- #

const TA_, TA_X_SA_X_NU = BioLab.SingleCell.target(
    Dict("Target 1" => ("[12]\$", "[34]\$"), "Target 2" => ("1\$", "3\$")),
    ("Group 1", "Group 2", "Group 3", "Group 4"),
)

@test TA_ == ["Target 2", "Target 1"]

@test isequal(TA_X_SA_X_NU, [0.0 NaN 1.0 NaN; 0 0 1 1])
