using Test: @test

using Random: seed!

using Nucleus

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

    @test Nucleus.String.is_bad(ba)

    #@btime Nucleus.String.is_bad($ba)

end

# ---- #

const GO_ = (
    # 40.152 ns (0 allocations: 0 bytes)
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

    @test !Nucleus.String.is_bad(go)

    #@btime Nucleus.String.is_bad($go)

end

# ---- #

for (st, re) in (("A_b.C-d+E!f%G%h]IjK", "A_b.C_d_E_f_G_h_IjK"),)

    @test Nucleus.String.clean(st) === re

    # 338.470 ns (4 allocations: 232 bytes)
    #@btime Nucleus.String.clean($st)

end

# ---- #

seed!(20231102)

# ---- #

for (ar_, re) in (((), "TJRIUDqZ"), ((('A', 'C', 'G', 'T'),), "CGCCGTTG"), (('A':'Z', 2), "WP"))

    @test Nucleus.String.make(ar_...) === re

end

# ---- #

for (st, re) in (
    ("0", 0),
    ("-0.0", 0),
    ("0.0", 0),
    ("0.1", 0.1),
    (".1", 0.1),
    ('a', 'a'),
    ("Aa", "Aa"),
    ("1/2", "1/2"),
)

    @test Nucleus.String.try_parse(st) === re

    # 41.498 ns (0 allocations: 0 bytes)
    # 46.932 ns (0 allocations: 0 bytes)
    # 45.712 ns (0 allocations: 0 bytes)
    # 138.208 μs (2 allocations: 48 bytes)
    # 138.333 μs (2 allocations: 48 bytes)
    # 279.250 μs (8 allocations: 352 bytes)
    # 356.500 μs (20 allocations: 848 bytes)
    # 356.583 μs (20 allocations: 848 bytes)
    #@btime Nucleus.String.try_parse($st)

end

# ---- #

const STL = "Can"

# ---- #

for (n, re) in ((0, "..."), (1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test Nucleus.String.limit(STL, n) === re

    # 42.339 ns (5 allocations: 184 bytes)
    # 45.416 ns (5 allocations: 184 bytes)
    # 45.079 ns (5 allocations: 184 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    #@btime Nucleus.String.limit(STL, $n)

end

# ---- #

# 1.667 μs (5 allocations: 97.91 KiB)
#@btime Nucleus.String.limit($(repeat('a', 100001)), 100000);

# ---- #

const STS = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

# ---- #

const DE = '.'

# ---- #

for (id, re) in ((1, "a"), (2, "b"), (3, "c"), (26, "z"))

    @test Nucleus.String.split_get(STS, DE, id) == re

    # 89.596 ns (2 allocations: 272 bytes)
    # 116.793 ns (2 allocations: 272 bytes)
    # 140.534 ns (2 allocations: 272 bytes)
    # 686.947 ns (3 allocations: 1.25 KiB)
    #@btime Nucleus.String.split_get(STS, DE, $id)

end

# ---- #

for (st, re) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for n in (-2, 2, -1, 1, 0)

        if abs(n) <= 1

            re2 = st

        else

            re2 = re

        end

        @test Nucleus.String.count(n, st) === "$n $re2"

        # 163.158 ns (10 allocations: 448 bytes)
        # 162.318 ns (10 allocations: 448 bytes)
        # 111.667 ns (5 allocations: 248 bytes)
        # 110.737 ns (5 allocations: 248 bytes)
        # 110.290 ns (5 allocations: 248 bytes)
        # 143.894 ns (6 allocations: 272 bytes)
        # 143.011 ns (6 allocations: 272 bytes)
        # 111.769 ns (5 allocations: 248 bytes)
        # 110.887 ns (5 allocations: 248 bytes)
        # 110.392 ns (5 allocations: 248 bytes)
        # 142.068 ns (6 allocations: 272 bytes)
        # 141.041 ns (6 allocations: 272 bytes)
        # 111.216 ns (5 allocations: 248 bytes)
        # 110.305 ns (5 allocations: 248 bytes)
        # 109.795 ns (5 allocations: 248 bytes)
        # 171.585 ns (10 allocations: 448 bytes)
        # 170.547 ns (10 allocations: 448 bytes)
        # 110.213 ns (5 allocations: 256 bytes)
        # 109.319 ns (5 allocations: 256 bytes)
        # 108.871 ns (5 allocations: 256 bytes)
        # 177.068 ns (10 allocations: 432 bytes)
        # 176.176 ns (10 allocations: 432 bytes)
        # 111.801 ns (5 allocations: 248 bytes)
        # 110.872 ns (5 allocations: 248 bytes)
        # 110.392 ns (5 allocations: 248 bytes)
        #@btime Nucleus.String.count($n, $st)

    end

end
