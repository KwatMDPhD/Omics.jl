using Test: @test

using Nucleus

# ---- #

for (ro_, re) in (
    (['A', 'A'], (['A'], Bool[1 1])),
    (['A', 'B'], (['A', 'B'], Bool[1 0; 0 1])),
    (['B', 'A'], (['A', 'B'], Bool[0 1; 1 0])),
    (['A', 'A', 'B'], (['A', 'B'], Bool[1 1 0; 0 0 1])),
    (['B', 'B', 'A'], (['A', 'B'], Bool[0 0 1; 1 1 0])),
)

    @test isequal(Nucleus.Target.tabulate(ro_), re)

    # 221.509 ns (12 allocations: 1.02 KiB)
    # 234.589 ns (12 allocations: 1.02 KiB)
    # 235.336 ns (12 allocations: 1.02 KiB)
    # 242.029 ns (12 allocations: 1.02 KiB)
    # 242.593 ns (12 allocations: 1.02 KiB)
    #@btime Nucleus.Target.tabulate($ro_)

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
        ([0, 7, 28], ["Participant 1", "Participant 2"], [10 20; 100 200; NaN 300]),
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
            [("Antigen 1", 0), ("Antigen 1", 7), ("Antigen 2", 0), ("Antigen 2", 7)],
            ["Sample 1", "Sample 2"],
            [0.0 0; 10 20; 0 0; 100 200],
        ),
    ),
)

    @test isequal(Nucleus.Target.tabulate(ro___, co___, fl_), re)

    # 636.725 ns (21 allocations: 2.16 KiB)
    # 548.797 ns (21 allocations: 2.11 KiB)
    # 550.358 ns (21 allocations: 2.11 KiB)
    # 629.935 ns (21 allocations: 2.14 KiB)
    # 636.411 ns (21 allocations: 2.14 KiB)
    # 680.921 ns (21 allocations: 2.12 KiB)
    # 622.093 ns (21 allocations: 2.19 KiB)
    # 1.092 μs (21 allocations: 2.55 KiB)
    #@btime Nucleus.Target.tabulate($ro___, $co___, $fl_)

end

# ---- #

for (ro_re_, co_, re) in ((
    Dict("Target 1" => ("[12]\$", "[34]\$"), "Target 2" => ("1\$", "3\$")),
    ["Group 1", "Group 2", "Group 3", "Group 4"],
    (["Target 2", "Target 1"], [0 NaN 1 NaN; 0 0 1 1]),
),)

    @test isequal(Nucleus.Target.tabulate(ro_re_, co_), re)

    # 6.233 μs (6 allocations: 320 bytes)
    #@btime Nucleus.Target.tabulate($ro_re_, $co_)

end
