using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is error("The sky is green.")

# ---- #

@test !Nucleus.Error.@is nothing

# ---- #

for ze in (0, 0.0)

    @test Nucleus.Error.@is Nucleus.Error.error_0(ze)

end

# ---- #

for nu in (1, 2.0, NaN, Inf)

    @test !Nucleus.Error.@is Nucleus.Error.error_0(nu)

end

# ---- #

for em in ((), [], "", Set(), Dict())

    @test Nucleus.Error.@is Nucleus.Error.error_empty(em)

end

# ---- #

for an_ in ((nothing,), [nothing], " ", Set((nothing,)), Dict(nothing => nothing))

    @test !Nucleus.Error.@is Nucleus.Error.error_empty(an_)

end

# ---- #

for an_ in (
    [nothing, nothing, missing, missing, missing, NaN, NaN, NaN, NaN, Inf, Inf, Inf, Inf, Inf],
    [1, 1.0, 1 // 1, true],
    ['a', 'b', 'b', 'c', 'c', 'c'],
)

    @test Nucleus.Error.@is Nucleus.Error.error_duplicate(an_)

end

# ---- #

for an_ in ([], [nothing, missing, NaN, Inf], [1], ['a', 'b', 'c'], ['a', "a"])

    @test !Nucleus.Error.@is Nucleus.Error.error_duplicate(an_)

end

# ---- #

for (fu, an_) in (
    (isnothing, [nothing]),
    (ismissing, [missing]),
    (isnan, [NaN]),
    (isinf, [Inf]),
    (Nucleus.String.is_bad, ["", " ", "!"]),
)

    @test Nucleus.Error.@is Nucleus.Error.error_bad(fu, an_)

    @test !Nucleus.Error.@is Nucleus.Error.error_bad(fu, [])

end

# ---- #

for an___ in (([], [1]), ([1], [1, 1]))

    @test Nucleus.Error.@is Nucleus.Error.error_length_difference(an___)

end

# ---- #

for an___ in (([], []), ([1], [1]), ([1, 1], [1, 1]))

    @test !Nucleus.Error.@is Nucleus.Error.error_length_difference(an___)

end

# ---- #

const KE_VA = Dict("Key" => "Value")

# ---- #

@test Nucleus.Error.@is Nucleus.Error.error_has_key(KE_VA, "Key")

# ---- #

@test !Nucleus.Error.@is Nucleus.Error.error_has_key(KE_VA, "New Key")

# ---- #

const EX = "extension"

# ---- #

for pa in ("file.$EX", joinpath(Nucleus.TE, "file.$EX"))

    @test Nucleus.Error.@is Nucleus.Error.error_extension_difference(pa, ".$EX")

    @test !Nucleus.Error.@is Nucleus.Error.error_extension_difference(pa, EX)

end

# ---- #

for pa in ("missing_file", joinpath(Nucleus.TE, "missing_path"))

    @test Nucleus.Error.@is Nucleus.Error.error_missing(pa)

end

# ---- #

for pa in (
    "Error.jl",
    "error.jl",
    joinpath(@__DIR__, "Error.jl"),
    joinpath(@__DIR__, "error.jl"),
    Nucleus.TE,
)

    @test !Nucleus.Error.@is Nucleus.Error.error_missing(pa)

end
