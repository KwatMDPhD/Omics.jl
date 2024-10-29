using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for (ta_, fe_, re) in (
    (
        [0, 0, 0, 1, 1, 1],
        [0, 0, 0, 2, 2, 2],
        [
            2.3504627745014825e-8,
            2.646552652540957e-5,
            0.02893859040955415,
            0.9710614095904461,
            0.9999735344734746,
            0.9999999764953722,
        ],
    ),
    (
        [1, 1, 1, 0, 0, 0],
        [0, 0, 0, 2, 2, 2],
        [
            0.9999999764953722,
            0.9999735344734746,
            0.9710614095904458,
            0.02893859040955395,
            2.6465526525409333e-5,
            2.350462774501466e-8,
        ],
    ),
)

    gl, p1f_, lo_, up_ = Omics.GL.fit(ta_, fe_)

    @test p1f_ == re

    Omics.GL.plot(
        "",
        "Sample",
        map(id -> "Sample $id", eachindex(fe_)),
        "Target",
        ta_,
        "Feature",
        fe_,
        p1f_,
        lo_,
        up_;
        si = 20,
    )

end

# ---- #

for ur in (10, 100, 1000)

    ta_ = rand((0, 1), ur)

    fe_ = sort!(randn(ur))

    gl, p1f_, lo_, up_ = Omics.GL.fit(ta_, fe_)

    Omics.GL.plot(
        "",
        "Sample",
        map(id -> "Sample $id", eachindex(fe_)),
        "Target",
        ta_,
        "Feature",
        fe_,
        p1f_,
        lo_,
        up_,
    )

end
