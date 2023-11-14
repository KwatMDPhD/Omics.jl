using Test: @test

using Nucleus

# ---- #

# TODO
Nucleus.FeatureXSample.log_intersection

# ---- #

# TODO
Nucleus.FeatureXSample.error_bad

# ---- #

# TODO
Nucleus.FeatureXSample.plot

# ---- #

const RO_ = (id -> "Row $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const ROU_ = unique(RO_)

# ---- #

const RO2U_ = replace.(ROU_, "Row" => "New Row")

# ---- #

@test Nucleus.FeatureXSample.transform(
    RO_,
    (id -> "Column $id").(1:3),
    reshape([2^po - 1 for po in 1:21], 7, 3);
    ro_ro2 = Dict(zip(ROU_, RO2U_)),
    lo = true,
) == (
    RO2U_,
    [
        1.584962500721156 8.584962500721156 15.584962500721156
        4.321928094887363 11.321928094887362 18.32192809488736
        5.321928094887363 12.321928094887362 19.32192809488736
        7 14 21
    ],
)

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    Nucleus.FeatureXSample.count_unique(na_, an___)

end
