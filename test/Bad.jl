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

for an in (nothing, missing, NaN, -Inf, Inf, -0.0, "α", "π", SP_..., SP_ .^ 2...)

    @test BioLab.Bad.is(an)

end

# ---- #

for an in (
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
)

    @test !BioLab.Bad.is(an)

end
