using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is error("The sky is green.")

@test !BioLab.Error.@is nothing

# ---- #

include("Bad.jl")

@test BioLab.Error.@is BioLab.Error.error_bad(BA_)

@test !BioLab.Error.@is BioLab.Error.error_bad(GO_)

# ---- #

for an_ in ((), ('a', 'a'), ('b', 'b', 'b', 'c', 'c', 'c', 'c'), (1, 1.0, 1 // 1, true))

    @test BioLab.Error.@is BioLab.Error.error_duplicate(an_)

end

# ---- #

for an_ in (('a',), ('a', 'b'), (1, 2))

    @test !BioLab.Error.@is BioLab.Error.error_duplicate(an_)

end

# ---- #

for co_ in (((), (1,)), ((1,), (2, 3)))

    @test BioLab.Error.@is BioLab.Error.error_length_difference(co_)

end

# ---- #

for co_ in (((), ()), ((1,), (2,)), ((1, 2), (3, 4)))

    @test !BioLab.Error.@is BioLab.Error.error_length_difference(co_)

end

# ---- #

const KE_VA = Dict("Key" => "Value")

@test BioLab.Error.@is BioLab.Error.error_has_key(KE_VA, "Key")

@test !BioLab.Error.@is BioLab.Error.error_has_key(KE_VA, "New Key")

# ---- #

for pa in ("file.extension", joinpath(BioLab.TE, "file.extension"))

    for ex in (".extension", "another_extension")

        @test BioLab.Error.@is BioLab.Error.error_extension_difference(pa, ex)

    end

    @test !BioLab.Error.@is BioLab.Error.error_extension_difference(pa, "extension")

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
