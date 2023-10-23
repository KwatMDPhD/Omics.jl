using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "SingleCell")

# ---- #

@test Nucleus.Path.read(DA) == ["7166_mr_87_filtered", "7166_mr_96_filtered"]

# ---- #

const SA_DI = (
    var"Sample 96" = joinpath(DA, "7166_mr_96_filtered"),
    var"Sample 87" = joinpath(DA, "7166_mr_87_filtered"),
)

# ---- #

const FE_, BA_, FE_X_BA_X_CO, SA_ = Nucleus.SingleCell.read(SA_DI)

# ---- #

@test (lastindex(FE_), lastindex(BA_)) === size(FE_X_BA_X_CO) === (56858, 5158)

# ---- #

@test lastindex(BA_) === lastindex(SA_)

# ---- #

#disable_logging(Warn)

# ---- #

# 7.126 s (48442102 allocations: 7.47 GiB)
#@btime Nucleus.SingleCell.read(SA_DI);
