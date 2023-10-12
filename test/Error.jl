using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is error("The sky is green.")

# ---- #

@test !BioLab.Error.@is nothing

# ---- #

for em in ("", (), [], Set(), Dict())

    @test BioLab.Error.@is BioLab.Error.error_empty(em)

end

# ---- #

for an_ in (" ", (nothing,), [nothing], Set((nothing,)), Dict(nothing => nothing))

    @test !BioLab.Error.@is BioLab.Error.error_empty(an_)

end

# ---- #

for an_ in (
    ('a', 'b', 'b', 'c', 'c', 'c'),
    (1, 1.0, 1 // 1, true),
    (
        nothing,
        nothing,
        missing,
        missing,
        missing,
        NaN,
        NaN,
        NaN,
        NaN,
        -Inf,
        -Inf,
        -Inf,
        -Inf,
        -Inf,
        Inf,
        Inf,
        Inf,
        Inf,
        Inf,
        Inf,
    ),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Error.@is BioLab.Error.error_duplicate(an2_)

    end

end

# ---- #

for an_ in (('a', 'b', 'c'), (1,), (nothing, missing, NaN, -Inf, Inf))

    for an2_ in (an_, collect(an_))

        @test !BioLab.Error.@is BioLab.Error.error_duplicate(an2_)

    end

end

# ---- #

for (fu, an_) in (
    (isnothing, (nothing, 0)),
    (ismissing, (missing,)),
    (isnan, (NaN,)),
    (isinf, (-Inf, Inf)),
    (BioLab.String.is_bad, ("", " ", "!")),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Error.@is BioLab.Error.error_bad(fu, an2_)

    end

    @test !BioLab.Error.@is BioLab.Error.error_bad(fu, Vector{Any}())

end

# ---- #

for an___ in (((), (1,)), ((1,), (1, 1)))

    for an2___ in (an___, collect(an___))

        @test BioLab.Error.@is BioLab.Error.error_length_difference(an2___)

    end

end

# ---- #

for an___ in (((), ()), ((1,), (1,)), ((1, 1), (1, 1)))

    for an2___ in (an___, collect(an___))

        @test !BioLab.Error.@is BioLab.Error.error_length_difference(an2___)

    end

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

    for ex in (".$EX", "another_extension")

        @test BioLab.Error.@is BioLab.Error.error_extension_difference(pa, ex)

    end

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
