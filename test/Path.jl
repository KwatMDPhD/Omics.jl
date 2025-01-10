using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const WO = pwd()

const PA = pkgdir(Omics)

for (ro, re) in ((dirname(PA), "Omics.jl/test"), (PA, "test"), (WO, ""))

    @test Omics.Path.shorten(WO, ro) == re

end

# ---- #

Omics.Path.ope(homedir())
