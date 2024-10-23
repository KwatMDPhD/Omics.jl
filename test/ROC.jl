using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const MA = Omics.ROC.make_matrix()

# ---- #

const LA_ = [1, 1, 2, 2]

const PR_ = [0, 0.4, 0.6, 1]

for (th, re) in (
    (
        0,
        [
            0 2
            0 2
        ],
    ),
    (
        0.4,
        [
            1 1
            0 2
        ],
    ),
    (
        0.5,
        [
            2 0
            0 2
        ],
    ),
    (
        0.6,
        [
            2 0
            0 2
        ],
    ),
    (
        0.7,
        [
            2 0
            1 1
        ],
    ),
    (
        1,
        [
            2 0
            1 1
        ],
    ),
)

    fill!(MA, zero(UInt))

    Omics.ROC.fill_matrix!(MA, LA_, PR_, th)

    @test MA == re

    # 8.041 ns (0 allocations: 0 bytes)
    # 5.958 ns (0 allocations: 0 bytes)
    # 7.958 ns (0 allocations: 0 bytes)
    # 7.958 ns (0 allocations: 0 bytes)
    # 6.000 ns (0 allocations: 0 bytes)
    # 6.541 ns (0 allocations: 0 bytes)
    @btime Omics.ROC.fill_matrix!(MA, LA_, PR_, $th)

end

# ---- #

Omics.ROC.plot_matrix("", MA, Omics.ROC.summarize_matrix(MA)...)

# ---- #

const UT = 4

for (la_, pr_) in (
    ([1, 1, 1, 1, 1, 2, 2, 2, 2, 2], [0.0, 0, 0, 0, 0, 1, 1, 1, 1, 1]),
    (
        [1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2],
        [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
    ),
)

    Omics.ROC.plot_line("", Omics.ROC.make_line(la_, pr_)...)

end

# ---- #

Omics.ROC.plot_line(
    "",
    Omics.ROC.make_line(
        [1, 2, 2, 1, 2, 1, 1, 1, 2, 1],
        [0.98, 0.67, 0.58, 0.78, 0.85, 0.86, 0.79, 0.89, 0.82, 0.86],
        (0.6, 0.7, 0.8),
    )...,
)

[
    0 1
    0.25 0.75
]

[
    0 1
    0.5 0.5
]

[
    0.3333333333333333 0.6666666666666666
    0.5 0.5
]
