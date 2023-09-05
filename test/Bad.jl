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

for an in (nothing, missing, NaN, -Inf, Inf, "", "α", "π", SP_..., SP_ .^ 2...)

    @test BioLab.Bad.is(an)

end

for an in (
    -0.0,
    0.0,
    1.0,
    "A",
    "Abc",
    ("A$sp" for sp in SP_)...,
    ("$(sp)B" for sp in SP_)...,
    ("A$(sp)B" for sp in SP_)...,
    1,
    'A',
)

    @test !BioLab.Bad.is(an)

end
