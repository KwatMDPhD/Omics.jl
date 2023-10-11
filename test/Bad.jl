using Test: @test

using BioLab

# ---- #

const SP_ = (
    " ",
    "!",
    "\"",
    "#",
    "%",
    "&",
    "'",
    "(",
    ")",
    "*",
    "+",
    ",",
    "-",
    ".",
    "/",
    ":",
    ";",
    "<",
    "=",
    ">",
    "?",
    "@",
    "[",
    "]",
    "^",
    "_",
    "`",
    "{",
    "|",
    "}",
    "~",
)

# ---- #

const BA_ = (
    # 0.833 ns (0 allocations: 0 bytes)
    nothing,
    # 0.875 ns (0 allocations: 0 bytes)
    missing,
    # 1.500 ns (0 allocations: 0 bytes)
    NaN,
    -Inf,
    Inf,
    # 1.791 ns (0 allocations: 0 bytes)
    "",
    # 41.792 ns (0 allocations: 0 bytes)
    "α",
    "π",
    # 41.204 ns (0 allocations: 0 bytes)
    SP_...,
    # 42.213 ns (0 allocations: 0 bytes)
    SP_ .^ 2...,
)

# ---- #

for ba in BA_

    @test BioLab.Bad.is(ba)

    #@btime BioLab.Bad.is($ba)

end

# ---- #

const GO_ = (
    # 0.875 ns (0 allocations: 0 bytes)
    1,
    'A',
    # 1.500 ns (0 allocations: 0 bytes)
    -0.0,
    0.0,
    1.0,
    # 40.112 ns (0 allocations: 0 bytes)
    "A",
    "Abc",
    ("A$sp" for sp in SP_)...,
    # 41.877 ns (0 allocations: 0 bytes)
    ("$(sp)B" for sp in SP_)...,
    # 40.152 ns (0 allocations: 0 bytes)
    ("A$(sp)B" for sp in SP_)...,
)

# ---- #

for go in GO_

    @test !BioLab.Bad.is(go)

    #@btime BioLab.Bad.is($go)

end
