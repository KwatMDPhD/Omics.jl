using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "SingleCell")

@test BioLab.Path.read(DA) == ["7166_mr_87_filtered", "7166_mr_96_filtered"]

# ---- #

const FE_, BA_, FE_X_BA_X_CO, SA_ = BioLab.SingleCell.read(
    Dict(
        sa => joinpath(DA, di) for (sa, di) in
        (("Sample 96", "7166_mr_96_filtered"), ("Sample 87", "7166_mr_87_filtered"))
    ),
)

const N_FE = 56858

const N_BA = 5158

@test length(FE_) == N_FE

@test length(BA_) == N_BA

@test size(FE_X_BA_X_CO) == (N_FE, N_BA)

@test length(SA_) == N_BA
