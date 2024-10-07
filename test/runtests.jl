using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in ("Color", "Palette", "Strin")

    @info mo

    run(`julia --project $mo.jl`)

end
