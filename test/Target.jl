using Test: @test

using BioLab

# ---- #

for (an_, re) in (
    (['A', 'A'], (['A'], Bool[1 1])),
    (['A', 'B'], (['A', 'B'], Bool[1 0; 0 1])),
    (['B', 'A'], (['A', 'B'], Bool[0 1; 1 0])),
    (['A', 'A', 'B'], (['A', 'B'], Bool[1 1 0; 0 0 1])),
    (['B', 'B', 'A'], (['A', 'B'], Bool[0 0 1; 1 1 0])),
)

    @assert isequal(BioLab.Target.make_any_x_index_x_bit(an_), re)

end

# ---- #

for ((an1_, la_, fi, an2_), re) in (
    (
        (["Row 1", "Row 2"], ["Label 1", "Label 1"], 0, [1, 2]),
        (["Row 1", "Row 2"], ["Label 1"], [1; 2;;]),
    ),
    (
        (["Row 2", "Row 1"], ["Label 1", "Label 1"], 0, [2, 1]),
        (["Row 1", "Row 2"], ["Label 1"], [1; 2;;]),
    ),
    (
        (["Row 1", "Row 2", "Row 3"], ["Label 1", "Label2", "Label 1"], 0, [1, 2, 3]),
        (["Row 1", "Row 2", "Row 3"], ["Label 1", "Label2"], [1 0; 0 2; 3 0]),
    ),
    (
        (["Row 3", "Row 2", "Row 1"], ["Label 1", "Label2", "Label 1"], 0, [1, 2, 3]),
        (["Row 1", "Row 2", "Row 3"], ["Label 1", "Label2"], [3 0; 0 2; 1 0]),
    ),
    (
        (
            ["Row 1", "Row 1", "Row 2", "Row 2"],
            ["Label 1", "Label 2", "Label 1", "Label 2"],
            0,
            [1, 2, 10, 20],
        ),
        (["Row 1", "Row 2"], ["Label 1", "Label 2"], [1 2; 10 20]),
    ),
    (
        (
            [0, 7, 0, 7, 28],
            ["Participant 1", "Participant 1", "Participant 2", "Participant 2", "Participant 2"],
            NaN,
            [10, 100, 20, 200, 300],
        ),
        ([0, 7, 28], ["Participant 1", "Participant 2"], [10 20; 100 200; NaN 300]),
    ),
)

    @assert isequal(BioLab.Target.make_any1_x_label_x_any2(an1_, la_, fi, an2_), re)

end

# ---- #

@test BioLab.Target.make_any1_x_label_x_any2(
    (
        (
            "Antigen 1",
            "Antigen 2",
            "Antigen 1",
            "Antigen 2",
            "Antigen 1",
            "Antigen 2",
            "Antigen 1",
            "Antigen 2",
        ),
        (0, 0, 7, 7, 0, 0, 7, 7),
    ),
    (
        "Sample 1",
        "Sample 1",
        "Sample 1",
        "Sample 1",
        "Sample 2",
        "Sample 2",
        "Sample 2",
        "Sample 2",
    ),
    NaN,
    (0, 0, 10, 100, 0, 0, 20, 200),
) == (
    ["Antigen 1_0", "Antigen 2_0", "Antigen 1_7", "Antigen 2_7"],
    ["Sample 1", "Sample 2"],
    [0.0 0.0; 0.0 0.0; 10.0 20.0; 100.0 200.0],
)
