using Test: @test

using BioLab

# ---- #

# ┌ Info: Column Row
# │ 1 Row 3.
# │ 1 Row 2.
# └ 1 Row 1.
# ┌ Info: Column 1
# │ 1 C.
# │ 1 A.
# └ 1 B.
# ┌ Info: Column 2
# │ 2 B.
# └ 1 A.
# ┌ Info: Column 3
# └ 3 C.
BioLab.FeatureXSample.count(
    ("Column Row", "Column 1", "Column 2", "Column 3"),
    ((id -> "Row $id").(1:3), ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
)

# ---- #

const FE_ = (nu -> "Feature $nu").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const SA_ = ["Sample 1"]

# ---- #

const FEU_ = unique(FE_)

# ---- #

const FE2U_ = replace.(FEU_, "Feature" => "New Feature")

# ---- #

@test BioLab.FeatureXSample.transform(
    BioLab.TE,
    FE_,
    SA_,
    [fl for fl in [-1.0, 1, 0, -2, 2, 8, 7], _ in 1:1],
    fe_fe2 = Dict(zip(FEU_, FE2U_)),
    fu = BioLab.FeatureXSample.median,
    ty = Float64,
    lo = true,
    na = "Test",
) == (FE2U_, [fl for fl in 0.0:3, _ in 1:1])
