using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is error("The sky is green.")

# ---- #

@test !BioLab.Error.@is nothing

# ---- #

for em in ((), [], "", Set(), Dict())

    @test BioLab.Error.@is BioLab.Error.error_empty(em)

end

# ---- #

for an_ in ((nothing,), [nothing], " ", Set((nothing,)), Dict(nothing => nothing))

    @test !BioLab.Error.@is BioLab.Error.error_empty(an_)

end

# ---- #

for an_ in (
    [nothing, nothing, missing, missing, missing, NaN, NaN, NaN, NaN, Inf, Inf, Inf, Inf, Inf],
    [1, 1.0, 1 // 1, true],
    ['a', 'b', 'b', 'c', 'c', 'c'],
)

    @test BioLab.Error.@is BioLab.Error.error_duplicate(an_)

end

# ---- #

for an_ in ([], [nothing, missing, NaN, Inf], [1], ['a', 'b', 'c'], ['a', "a"])

    @test !BioLab.Error.@is BioLab.Error.error_duplicate(an_)

end

# ---- #

for (fu, an_) in (
    (isnothing, [nothing]),
    (ismissing, [missing]),
    (isnan, [NaN]),
    (isinf, [Inf]),
    (BioLab.String.is_bad, ["", " ", "!"]),
)

    @test BioLab.Error.@is BioLab.Error.error_bad(fu, an_)

    @test !BioLab.Error.@is BioLab.Error.error_bad(fu, [])

end

# ---- #

for an___ in (([], [1]), ([1], [1, 1]))

    @test BioLab.Error.@is BioLab.Error.error_length_difference(an___)

end

# ---- #

for an___ in (([], []), ([1], [1]), ([1, 1], [1, 1]))

    @test !BioLab.Error.@is BioLab.Error.error_length_difference(an___)

end

# ---- #

const KE_VA = Dict("Key" => "Value")

# ---- #

@test BioLab.Error.@is BioLab.Error.error_has_key(KE_VA, "Key")

# ---- #

@test !BioLab.Error.@is BioLab.Error.error_has_key(KE_VA, "New Key")

# ---- #

const EX = "extension"

# ---- #

for pa in ("file.$EX", joinpath(BioLab.TE, "file.$EX"))

    @test BioLab.Error.@is BioLab.Error.error_extension_difference(pa, ".$EX")

    @test !BioLab.Error.@is BioLab.Error.error_extension_difference(pa, EX)

end

# ---- #

for pa in ("missing_file", joinpath(BioLab.TE, "missing_path"))

    @test BioLab.Error.@is BioLab.Error.error_missing(pa)

end

# ---- #

for pa in (
    "Error.jl",
    "error.jl",
    joinpath(@__DIR__, "Error.jl"),
    joinpath(@__DIR__, "error.jl"),
    BioLab.TE,
)

    @test !BioLab.Error.@is BioLab.Error.error_missing(pa)

end
