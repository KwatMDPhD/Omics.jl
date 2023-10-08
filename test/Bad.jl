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
    # 0.875 ns (0 allocations: 0 bytes)
    nothing,
    # 0.875 ns (0 allocations: 0 bytes)
    missing,
    # 1.500 ns (0 allocations: 0 bytes)
    NaN,
    -Inf,
    Inf,
    # 1.791 ns (0 allocations: 0 bytes)
    "",
    # 42.171 ns (0 allocations: 0 bytes)
    "α",
    "π",
    # 41.582 ns (0 allocations: 0 bytes)
    SP_...,
    # 42.540 ns (0 allocations: 0 bytes)
    SP_ .^ 2...,
)

# ---- #

for ba in BA_

    @test BioLab.Bad.is(ba)

    @btime BioLab.Bad.is($ba)

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
    # 40.660 ns (0 allocations: 0 bytes)
    "A",
    "Abc",
    ("A$sp" for sp in SP_)...,
    # 42.172 ns (0 allocations: 0 bytes)
    ("$(sp)B" for sp in SP_)...,
    # 40.657 ns (0 allocations: 0 bytes)
    ("A$(sp)B" for sp in SP_)...,
)

# ---- #

for go in GO_

    @test !BioLab.Bad.is(go)

    @btime BioLab.Bad.is($go)

end
