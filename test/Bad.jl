include("environment.jl")

# ---- #

for ty in (Float64, String)

    BioLab.print_header(ty)

    println(BioLab.Bad._get_bad(ty))

end

# ---- #

for (an, ty) in (
    (1, Float64),
    (missing, Float64),
    (-Inf, Float64),
    (Inf, Float64),
    (NaN, Float64),
    ('a', String),
    ("", String),
)

    @test @is_error BioLab.Bad.error_bad(an, ty)

end

# ---- #

for (an, ty) in ((1.0, Float64), ("a", String), (0, Int))

    @test !@is_error BioLab.Bad.error_bad(an, ty)

end
