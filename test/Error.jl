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

for an_ in ((), ('a', 'a'), ('a', 'a', 'a', 'b', 'b'), (1, 1.0))

    @test BioLab.Error.@is_error BioLab.Error.error_duplicate(an_)

end

for an_ in (('a', 'b'), (1, 2))

    @test !BioLab.Error.@is_error BioLab.Error.error_duplicate(an_)

end

# ---- #

const SP_ = (
    " ",
    ",",
    ".",
    ";",
    ":",
    "?",
    "!",
    "(",
    ")",
    "[",
    "]",
    "{",
    "}",
    "<",
    ">",
    "=",
    "~",
    "+",
    "-",
    "*",
    "^",
    "/",
    "%",
    "|",
    "&",
    "_",
    "@",
    "#",
    "\"",
    "\'",
    "`",
)

@test BioLab.Error.@is_error BioLab.Error.error_bad((
    nothing,
    missing,
    NaN,
    -Inf,
    Inf,
    "",
    "α",
    "π",
    SP_...,
))

@test !BioLab.Error.@is_error BioLab.Error.error_bad((
    -0.0,
    0.0,
    1.0,
    1,
    "Abc",
    "A",
    "a",
    string.("A", SP_)...,
    string.(SP_, "A")...,
    string.("A", SP_, "B")...,
    'A',
))

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
