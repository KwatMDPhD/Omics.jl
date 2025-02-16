using Test: @test

using Omics

# ---- #

const PA = joinpath(pwd(), "Path.jl")

const DI = pkgdir(Omics)

for (di, re) in
    ((dirname(DI), "Omics.jl/test/Path.jl"), (DI, "test/Path.jl"), (pwd(), "Path.jl"))

    @test Omics.Path.shorten(PA, di) == re

end

# ---- #

Omics.Path.wai("nonexistent.file")

# ---- #

Omics.Path.ope(homedir())
