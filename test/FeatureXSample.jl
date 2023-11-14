using Test: @test

using Nucleus

# ---- #

for an___ in ((Int[], Int[]), ([1], [2, 3, 4]), (['a'], ['b', 'c']))

    @test Nucleus.Error.@is Nucleus.FeatureXSample.log_intersection(an___, intersect(an___...))

end

# ---- #

for an___ in (([1, 2], [2, 3, 4]), (['a', 'b', 'c'], ['b', 'c']))

    Nucleus.FeatureXSample.log_intersection(an___, intersect(an___...))

end

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    Nucleus.FeatureXSample.count_unique(na_, an___)

end

# ---- #

const NAR = "Row"

# ---- #

const NAC = "Column"

# ---- #

const RO_ = (id -> "$NAR $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const CO_ = (id -> "$NAC $id").(1:3)

# ---- #

const NU = reshape([2^po - 1 for po in 1:21], 7, 3)

# ---- #

Nucleus.FeatureXSample._plot(NAR, RO_, NAC, CO_, "Number", NU)

# ---- #

const ROU_ = unique(RO_)

# ---- #

const RO2U_ = replace.(ROU_, NAR => "New $NAR")

# ---- #

@test Nucleus.FeatureXSample.transform(RO_, CO_, NU; ro_ro2 = Dict(zip(ROU_, RO2U_)), lo = true) ==
      (
    RO2U_,
    [
        1.584962500721156 8.584962500721156 15.584962500721156
        4.321928094887363 11.321928094887362 18.32192809488736
        5.321928094887363 12.321928094887362 19.32192809488736
        7 14 21
    ],
)
