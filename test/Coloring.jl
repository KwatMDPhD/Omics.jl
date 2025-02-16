using Colors: RGB

using Test: @test

using Omics

# ---- #

for (co_, re) in (
    (("#ff0000",), ((0.0, "#ff0000"), (1.0, "#ff0000"))),
    (("#ff0000", "#00ff00"), ((0.0, "#ff0000"), (1.0, "#00ff00"))),
    (
        ("#ff0000", "#00ff00", "#0000ff"),
        ((0.0, "#ff0000"), (0.5, "#00ff00"), (1.0, "#0000ff")),
    ),
)

    @test Omics.Coloring.fractionate(co_) === re

end

# ---- #

const CO = Omics.Coloring.make(["#ff0000", "#00ff00", "#0000ff"])

@test lastindex(CO) === 3

@test CO[1] == CO[0.0] === CO[-0.1] === RGB(1, 0, 0.0)

@test CO[3] == CO[1.0] === CO[1.1] === RGB(0, 0, 1.0)
