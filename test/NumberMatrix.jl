using Test: @test

# ---- #

for (an___, re) in (
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 2", 10, 20],
            ["Row 3", 100, 200],
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => [1.0, 10, 100],
            "Column 2" => [2.0, 20, 200],
        ),
    ),
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 1", 10, 20],
            ["Row 2", 100, 200],
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2"],
            "Column 1" => [5.5, 100],
            "Column 2" => [11.0, 200],
        ),
    ),
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 1", 10, 20],
            ["Row 1", 100, 200],
        ),
        DataFrame("Row Name" => ["Row 1"], "Column 1" => [37.0], "Column 2" => [74.0]),
    ),
)

    @test BioLab.DataFrame.collapse(BioLab.DataFrame.make(an___)) == re

end
