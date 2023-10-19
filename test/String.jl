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
    # 41.666 ns (0 allocations: 0 bytes)
    "α",
    "π",
    # 41.035 ns (0 allocations: 0 bytes)
    SP_...,
    # 41.961 ns (0 allocations: 0 bytes)
    SP_ .^ 2...,
)

# ---- #

for ba in BA_

    @test BioLab.String.is_bad(ba)

    #@btime BioLab.String.is_bad($ba)

end

# ---- #

const GO_ = (
    # 40.111 ns (0 allocations: 0 bytes)
    "A",
    # 40.152 ns (0 allocations: 0 bytes)
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

    #@btime BioLab.String.is_bad($go)

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

    # 41.498 ns (0 allocations: 0 bytes)
    # 46.932 ns (0 allocations: 0 bytes)
    # 45.748 ns (0 allocations: 0 bytes)
    # 140.667 μs (2 allocations: 48 bytes)
    # 140.666 μs (2 allocations: 48 bytes)
    # 367.750 μs (20 allocations: 848 bytes)
    # 285.042 μs (8 allocations: 352 bytes)
    # 368.208 μs (20 allocations: 848 bytes)
    #@btime BioLab.String.try_parse($st)

end

# ---- #

const STL = "Can"

# ---- #

for (n, re) in ((0, "..."), (1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test BioLab.String.limit(STL, n) === re

    # 42.339 ns (5 allocations: 184 bytes)
    # 45.416 ns (5 allocations: 184 bytes)
    # 45.079 ns (5 allocations: 184 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    #@btime BioLab.String.limit(STL, $n)

end

# ---- #

# 1.667 μs (5 allocations: 97.91 KiB)
#@btime BioLab.String.limit($(repeat('a', 100001)), 100000);

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
    #@btime BioLab.String.split_get(STS, DE, $id)

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

        # 212.108 ns (9 allocations: 448 bytes)
        # 110.559 ns (5 allocations: 248 bytes)
        # 109.263 ns (5 allocations: 248 bytes)
        # 109.750 ns (5 allocations: 248 bytes)
        # 211.343 ns (9 allocations: 448 bytes)
        # 200.705 ns (8 allocations: 408 bytes)
        # 109.454 ns (5 allocations: 248 bytes)
        # 108.110 ns (5 allocations: 248 bytes)
        # 108.548 ns (5 allocations: 248 bytes)
        # 199.790 ns (8 allocations: 408 bytes)
        # 137.062 ns (5 allocations: 248 bytes)
        # 108.871 ns (5 allocations: 248 bytes)
        # 107.398 ns (5 allocations: 248 bytes)
        # 107.967 ns (5 allocations: 248 bytes)
        # 136.246 ns (5 allocations: 248 bytes)
        # 219.393 ns (9 allocations: 448 bytes)
        # 108.011 ns (5 allocations: 256 bytes)
        # 106.535 ns (5 allocations: 256 bytes)
        # 106.983 ns (5 allocations: 256 bytes)
        # 218.232 ns (9 allocations: 448 bytes)
        # 224.455 ns (9 allocations: 440 bytes)
        # 109.531 ns (5 allocations: 248 bytes)
        # 108.065 ns (5 allocations: 248 bytes)
        # 108.647 ns (5 allocations: 248 bytes)
        # 223.635 ns (9 allocations: 440 bytes)
        #@btime BioLab.String.count($n, $st)

    end

end
