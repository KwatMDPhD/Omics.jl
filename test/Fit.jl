using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for (ta_, fe_, p1f_) in (
    ([0, 0, 0, 1, 1, 1], [0, 0, 0, 2, 2, 2], [0, 0, 0, 1, 1, 1]),
    ([1, 1, 1, 0, 0, 0], [2, 2, 2, 0, 0, 0], [1, 1, 1, 0, 0, 0]),
    ([0, 1, 0, 1, 0, 1], [0, 2, 0, 2, 0, 2], [0, 1, 0, 1, 0, 1]),
    ([0, 0, 0, 1, 1, 1], [2, 2, 2, 0, 0, 0], [0, 0, 0, 1, 1, 1]),
    ([1, 1, 1, 0, 0, 0], [0, 0, 0, 2, 2, 2], [1, 1, 1, 0, 0, 0]),
    ([0, 1, 0, 1, 0, 1], [2, 0, 2, 0, 2, 0], [0, 1, 0, 1, 0, 1]),
)

    Omics.Fit.plot(
        "",
        "Sample",
        map(id -> "_$id", eachindex(ta_)),
        "Target",
        ta_,
        "Feature",
        fe_,
        p1f_,
        map(nu -> nu - 0.1, p1f_),
        map(nu -> nu + 0.1, p1f_);
        si = 24,
    )

end
