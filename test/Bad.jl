using Test: @test

using BioLab

# ---- #

for an in (nothing, missing, NaN, -Inf, Inf, -0.0, "", " ", "  ")

    @test BioLab.Bad.is_bad(an)

end

# ---- #

for an in (0.0, 1.0, " a ", 1, 'a')

    @test !BioLab.Bad.is_bad(an)

end
