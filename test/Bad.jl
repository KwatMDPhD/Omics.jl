using Test: @test

using BioLab

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

# ---- #

for an in (nothing, missing, NaN, -Inf, Inf, "", "α", "π", SP_..., SP_ .^ 2...)

    @test BioLab.Bad.is(an)

end

# ---- #

for an in (
    -0.0,
    0.0,
    1.0,
    "A",
    "Abc",
    string.('A', SP_)...,
    string.(SP_, 'B')...,
    string.('A', SP_, 'B')...,
    1,
    'A',
)

    @test !BioLab.Bad.is(an)

end
