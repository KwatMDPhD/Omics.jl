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

const BA_ = (nothing, missing, NaN, -Inf, Inf, "", "α", "π", SP_..., SP_ .^ 2...)

for an in BA_

    @test BioLab.Bad.is(an)

end

# ---- #

const GO_ = (
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

for an in GO_

    @test !BioLab.Bad.is(an)

end
