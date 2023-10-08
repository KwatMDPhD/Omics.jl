using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "SingleCell")

# ---- #

@test BioLab.Path.read(DA) == ["7166_mr_87_filtered", "7166_mr_96_filtered"]

# ---- #

const SA_DI = NamedTuple(
    Symbol(sa) => joinpath(DA, di) for
    (sa, di) in (("Sample 96", "7166_mr_96_filtered"), ("Sample 87", "7166_mr_87_filtered"))
)

# ---- #

const FE_, BA_, FE_X_BA_X_CO, SA_ = BioLab.SingleCell.read(SA_DI)

# ---- #

@test (length(FE_), length(BA_)) === size(FE_X_BA_X_CO) === (56858, 5158)

# ---- #

@test length(BA_) === length(SA_)

# ---- #

disable_logging(Warn)

# ---- #

# 7.407 s (48499828 allocations: 9.42 GiB)
@btime BioLab.SingleCell.read($SA_DI);
