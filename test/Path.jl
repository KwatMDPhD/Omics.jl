using Test: @test

using Omics

# ---- #

const D1 = pwd()

const D2 = pkgdir(Omics)

for (di, re) in ((dirname(D2), "Omics.jl/test"), (D2, "test"), (D1, ""))

    @test Omics.Path.shorten(D1, di) == re

end

# ---- #

Omics.Path.wai("nonexistent.file")

# ---- #

Omics.Path.ope(homedir())
