using Test: @test

using Nucleus

# ---- #

Nucleus.DataFrame.read(joinpath(Nucleus._DA, "DataFrame", "titanic.tsv"))
