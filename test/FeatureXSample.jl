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

const NR = "Row"

# ---- #

const NC = "Column"

# ---- #

const RO_ = (id -> "$NR $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const CO_ = (id -> "$NC $id").(1:3)

# ---- #

const FL = reshape(1.0:21, 7, 3)

# ---- #

Nucleus.FeatureXSample.plot(NR, RO_, NC, CO_, "plot", FL)

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.write_plot("", NR, RO_, NC, CO_, "write_plot", FL)

# ---- #

Nucleus.FeatureXSample.write_plot(
    joinpath(Nucleus.TE, "write"),
    NR,
    RO_,
    NC,
    CO_,
    "write_plot",
    FL,
)

# ---- #

for fi in ("write.tsv", "write.html", "write.histogram.html")

    @test isfile(joinpath(Nucleus.TE, fi))

end

# ---- #

const UN_ = unique(RO_)

# ---- #

const U2_ = replace.(UN_, NR => "New $NR")

# ---- #

@test Nucleus.FeatureXSample.transform(
    RO_,
    CO_,
    FL;
    ro_r2 = Dict(zip(UN_, U2_)),
    lo = true,
    nn = "transform",
) == (
    U2_,
    [
        1.3219280948873624 3.2479275134435857 4.044394119358453
        2.321928094887362 3.584962500721156 4.247927513443585
        2.584962500721156 3.700439718141092 4.321928094887363
        3.0 3.9068905956085187 4.459431618637297
    ],
)
