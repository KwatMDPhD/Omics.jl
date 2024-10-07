using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

for st in ("red", "#f00", "#ff0000")

    @test Omics.Color.hexify(st, 0) === "#ff000000"

    @test Omics.Color.hexify(st, 0.5) === "#ff000080"

    @test Omics.Color.hexify(st) === "#ff0000ff"

end
