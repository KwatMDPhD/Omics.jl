using Test: @test

using Nucleus

# ---- #

@test (Nucleus.Path.@here) === "Pathhere"
