using Test: @test

using BioLab

# ---- #

for (ro_, re) in (
    (['A', 'A'], (['A'], Bool[1 1])),
    (['A', 'B'], (['A', 'B'], Bool[1 0; 0 1])),
    (['B', 'A'], (['A', 'B'], Bool[0 1; 1 0])),
    (['A', 'A', 'B'], (['A', 'B'], Bool[1 1 0; 0 0 1])),
    (['B', 'B', 'A'], (['A', 'B'], Bool[0 0 1; 1 1 0])),
)

    @test isequal(BioLab.Target.tabulate(ro_), re)

    # 251.482 ns (12 allocations: 1.02 KiB)
    # 281.098 ns (12 allocations: 1.02 KiB)
    # 289.963 ns (12 allocations: 1.02 KiB)
    # 271.729 ns (12 allocations: 1.02 KiB)
    # 277.253 ns (12 allocations: 1.02 KiB)
    #@btime BioLab.Target.tabulate($ro_)

end

# ---- #

for (ro___, co___, fl_, re) in (
    (
        (["Row 1", "Row 2", "Row 3"],),
        (["Column 1", "Column 2", "Column 3"],),
        [1.0, 2, 3],
        (
            ["Row 1", "Row 2", "Row 3"],
            ["Column 1", "Column 2", "Column 3"],
            [1 NaN NaN; NaN 2 NaN; NaN NaN 3],
        ),
    ),
    (
        (["Row 1", "Row 2"],),
        (["Label 1", "Label 1"],),
        [1.0, 2],
        (["Row 1", "Row 2"], ["Label 1"], [1.0; 2;;]),
    ),
    (
        (["Row 2", "Row 1"],),
        (["Label 1", "Label 1"],),
        [1.0, 2],
        (["Row 1", "Row 2"], ["Label 1"], [2.0; 1;;]),
    ),
    (
        (["Row 1", "Row 2", "Row 3"],),
        (["Label 1", "Label2", "Label 1"],),
        [1.0, 2, 3],
        (["Row 1", "Row 2", "Row 3"], ["Label 1", "Label2"], [1  NaN; NaN 2; 3 NaN]),
    ),
    (
        (["Row 3", "Row 2", "Row 1"],),
        (["Label 1", "Label2", "Label 1"],),
        [1.0, 2, 3],
        (["Row 1", "Row 2", "Row 3"], ["Label 1", "Label2"], [3 NaN; NaN 2; 1 NaN]),
    ),
    (
        (["Row 1", "Row 1", "Row 2", "Row 2"],),
        (["Label 1", "Label 2", "Label 1", "Label 2"],),
        [1.0, 2, 10, 20],
        (["Row 1", "Row 2"], ["Label 1", "Label 2"], [1.0 2; 10 20]),
    ),
    (
        ([0, 7, 0, 7, 28],),
        (["Participant 1", "Participant 1", "Participant 2", "Participant 2", "Participant 2"],),
        [10.0, 100, 20, 200, 300],
        (["0", "7", "28"], ["Participant 1", "Participant 2"], [10 20; 100 200; NaN 300]),
    ),
    (
        (
            [
                "Antigen 1",
                "Antigen 2",
                "Antigen 1",
                "Antigen 2",
                "Antigen 1",
                "Antigen 2",
                "Antigen 1",
                "Antigen 2",
            ],
            [0, 0, 7, 7, 0, 0, 7, 7],
        ),
        ([
            "Sample 1",
            "Sample 1",
            "Sample 1",
            "Sample 1",
            "Sample 2",
            "Sample 2",
            "Sample 2",
            "Sample 2",
        ],),
        [0.0, 0, 10, 100, 0, 0, 20, 200],
        (
            ["Antigen 1_0", "Antigen 1_7", "Antigen 2_0", "Antigen 2_7"],
            ["Sample 1", "Sample 2"],
            [0.0 0; 10 20; 0 0; 100 200],
        ),
    ),
)

    @test isequal(BioLab.Target.tabulate(ro___, co___, fl_), re)

    # 1.729 μs (65 allocations: 3.81 KiB)
    # 1.167 μs (44 allocations: 3.03 KiB)
    # 1.171 μs (44 allocations: 3.03 KiB)
    # 1.571 μs (58 allocations: 3.55 KiB)
    # 1.558 μs (58 allocations: 3.55 KiB)
    # 1.462 μs (51 allocations: 3.28 KiB)
    # 1.725 μs (64 allocations: 3.80 KiB)
    # 2.551 μs (81 allocations: 4.98 KiB)
    #@btime BioLab.Target.tabulate($ro___, $co___, $fl_)

end

# ---- #

for (ro_re_, co_, re) in ((
    Dict(
        # Tuple!
        "Target 1" => ("[12]\$", "[34]\$"),
        # Tuple!
        "Target 2" => ("1\$", "3\$"),
    ),
    ["Group 1", "Group 2", "Group 3", "Group 4"],
    (["Target 2", "Target 1"], [0 NaN 1 NaN; 0 0 1 1]),
),)

    @test isequal(BioLab.Target.tabulate(ro_re_, co_), re)

    # 6.258 μs (6 allocations: 320 bytes)
    #@btime BioLab.Target.tabulate($ro_re_, $co_)

end
