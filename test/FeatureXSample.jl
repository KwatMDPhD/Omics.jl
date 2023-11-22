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

const FL = reshape(1.0:21, 7, 3)

# ---- #

Nucleus.FeatureXSample.plot(NAR, RO_, NAC, CO_, "plot", FL)

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.write_plot("", NAR, RO_, NAC, CO_, "write_plot", FL)

# ---- #

Nucleus.FeatureXSample.write_plot(
    joinpath(Nucleus.TE, "write"),
    NAR,
    RO_,
    NAC,
    CO_,
    "write_plot",
    FL,
)

# ---- #

for fi in ("write.tsv", "write.html", "write.histogram.html")

    @test isfile(joinpath(Nucleus.TE, fi))

end

# ---- #

const ROU_ = unique(RO_)

# ---- #

const RO2U_ = replace.(ROU_, NAR => "New $NAR")

# ---- #

@test Nucleus.FeatureXSample.transform(
    RO_,
    CO_,
    FL;
    ro_ro2 = Dict(zip(ROU_, RO2U_)),
    lo = true,
    nan = "transform",
) == (
    RO2U_,
    [
        1.3219280948873624 3.2479275134435857 4.044394119358453
        2.321928094887362 3.584962500721156 4.247927513443585
        2.584962500721156 3.700439718141092 4.321928094887363
        3.0 3.9068905956085187 4.459431618637297
    ],
)
