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

    @test BioLab.String.is_bad(ba)

    @btime BioLab.String.is_bad($ba)

end

# ---- #

const GO_ = (
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

    @test !BioLab.String.is_bad(go)

    @btime BioLab.String.is_bad($go)

end

# ---- #

for (st, re) in (
    ("0", 0),
    ("-0.0", 0),
    ("0.0", 0),
    ("0.1", 0.1),
    (".1", 0.1),
    ("1/2", "1/2"),
    ('a', 'a'),
    ("Aa", "Aa"),
)

    @test BioLab.String.try_parse(st) === re

    # 41.414 ns (0 allocations: 0 bytes)
    # 46.932 ns (0 allocations: 0 bytes)
    # 45.753 ns (0 allocations: 0 bytes)
    # 135.750 μs (2 allocations: 48 bytes)
    # 135.666 μs (2 allocations: 48 bytes)
    # 349.375 μs (20 allocations: 848 bytes)
    # 276.458 μs (8 allocations: 352 bytes)
    # 349.875 μs (20 allocations: 848 bytes)
    @btime BioLab.String.try_parse($st)

end

# ---- #

const STL = "Can"

# ---- #

for (n, re) in ((0, "..."), (1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test BioLab.String.limit(STL, n) === re

    # 22.442 ns (1 allocation: 24 bytes)
    # 39.567 ns (2 allocations: 48 bytes)
    # 39.608 ns (2 allocations: 48 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    @btime BioLab.String.limit(STL, $n)

end

# ---- #

const STS = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

# ---- #

const DE = '.'

# ---- #

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    @test BioLab.String.split_get(STS, DE, id) == re

    # 87.813 ns (2 allocations: 272 bytes)
    # 475.551 ns (3 allocations: 1.25 KiB)
    # 687.358 ns (3 allocations: 1.25 KiB)
    @btime BioLab.String.split_get(STS, DE, $id)

end

# ---- #

for (st, re) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for n in (-2, -1, 0, 1, 2)

        if abs(n) <= 1

            re2 = st

        else

            re2 = re

        end

        @test BioLab.String.count(n, st) === "$n $re2"

        # 239.914 ns (9 allocations: 440 bytes)
        # 131.135 ns (5 allocations: 248 bytes)
        # 130.096 ns (5 allocations: 248 bytes)
        # 130.379 ns (5 allocations: 248 bytes)
        # 239.104 ns (9 allocations: 440 bytes)
        # 224.981 ns (8 allocations: 408 bytes)
        # 130.502 ns (5 allocations: 248 bytes)
        # 128.943 ns (5 allocations: 248 bytes)
        # 129.326 ns (5 allocations: 248 bytes)
        # 223.849 ns (8 allocations: 408 bytes)
        # 156.984 ns (5 allocations: 248 bytes)
        # 129.233 ns (5 allocations: 248 bytes)
        # 128.273 ns (5 allocations: 248 bytes)
        # 128.613 ns (5 allocations: 248 bytes)
        # 156.250 ns (5 allocations: 248 bytes)
        # 248.344 ns (9 allocations: 440 bytes)
        # 129.576 ns (5 allocations: 256 bytes)
        # 129.138 ns (5 allocations: 256 bytes)
        # 128.762 ns (5 allocations: 256 bytes)
        # 247.172 ns (9 allocations: 440 bytes)
        # 251.016 ns (9 allocations: 432 bytes)
        # 129.860 ns (5 allocations: 248 bytes)
        # 128.903 ns (5 allocations: 248 bytes)
        # 129.279 ns (5 allocations: 248 bytes)
        # 250.228 ns (9 allocations: 432 bytes)
        @btime BioLab.String.count($n, $st)

    end

end
