include("environment.jl")

# ---- #

for (ty, re) in ((Float64, (-Inf, Inf, NaN)), (String, ("",)))

    @test isequal(BioLab.Bad._get_bad(ty), re)

end

# ---- #

for (an, ty) in (
    (nothing, Float64),
    (missing, Float64),
    (1, Float64),
    (-Inf, Float64),
    (Inf, Float64),
    (NaN, Float64),
    ('a', String),
    ("", String),
)

    @test @is_error BioLab.Bad.error_bad_type(an, ty)

end

# ---- #

for (an, ty) in ((1.0, Float64), ("a", String), (0, Int))

    BioLab.Bad.error_bad_type(an, ty)

end
