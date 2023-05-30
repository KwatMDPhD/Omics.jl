include("environment.jl")

# ---- #

for (nu, re) in (
    (-0, "0"),
    (0, "0"),
    (-0.0, "0"),
    (0.0, "0"),
    (1 / 3, "0.3333"),
    (0.1234567890123456789, "0.1235"),
    (0.001, "0.001"),
    (0.000001, "1e-06"),
)

    @test isequal(BioLab.Number.format(nu), re)

end

# ---- #

for ra in 0:28

    println(BioLab.Number.rank_in_fraction(ra))

end
