using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is_error error("This is an error message.")

@test !BioLab.Error.@is_error "This is not an error message."

# ---- #

const KE_VA = Dict("Key" => "Value")

@test BioLab.Error.@is_error BioLab.Error.error_has_key(KE_VA, "Key")

@test !BioLab.Error.@is_error BioLab.Error.error_has_key(KE_VA, "New Key")

# ---- #

for pa in ("missing_file", joinpath(BioLab.TE, "missing_path"))

    @test BioLab.Error.@is_error BioLab.Error.error_missing(pa)

end

for pa in
    ("Path.jl", "path.jl", joinpath(@__DIR__, "Path.jl"), joinpath(@__DIR__, "path.jl"), BioLab.TE)

    @test !BioLab.Error.@is_error BioLab.Error.error_missing(pa)

end

# ---- #

for pa in ("file.extension", joinpath(BioLab.TE, "file.extension"))

    for ex in (".extension", "another_extension")

        @test BioLab.Error.@is_error BioLab.Error.error_extension_difference(pa, ex)

    end

    @test !BioLab.Error.@is_error BioLab.Error.error_extension_difference(pa, "extension")

end
