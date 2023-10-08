using Test: @test

using BioLab

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
    # 47.228 ns (0 allocations: 0 bytes)
    # 46.596 ns (0 allocations: 0 bytes)
    # 138.125 μs (2 allocations: 48 bytes)
    # 138.209 μs (2 allocations: 48 bytes)
    # 356.500 μs (20 allocations: 848 bytes)
    # 284.750 μs (8 allocations: 352 bytes)
    # 356.917 μs (20 allocations: 848 bytes)
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
    @btime BioLab.String.limit($STL, $n)

end

# ---- #

const STS = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

# ---- #

const DE = '.'

# ---- #

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    @test BioLab.String.split_get(STS, DE, id) === re

    # 87.813 ns (2 allocations: 272 bytes)
    # 475.551 ns (3 allocations: 1.25 KiB)
    # 687.358 ns (3 allocations: 1.25 KiB)
    @btime BioLab.String.split_get($STS, $DE, $id)

end

# ---- #

@test BioLab.Error.@is BioLab.String.count(-1, "Car")

# ---- #

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for (n, re) in ((0, "0 $si"), (1, "1 $si"), (2, "2 $pl"))

        @test BioLab.String.count(n, si) === re

        # 111.801 ns (5 allocations: 248 bytes)
        # 112.297 ns (5 allocations: 248 bytes)
        # 209.785 ns (9 allocations: 440 bytes)
        # 110.558 ns (5 allocations: 248 bytes)
        # 111.081 ns (5 allocations: 248 bytes)
        # 195.687 ns (8 allocations: 408 bytes)
        # 109.943 ns (5 allocations: 248 bytes)
        # 110.424 ns (5 allocations: 248 bytes)
        # 140.589 ns (5 allocations: 248 bytes)
        # 109.795 ns (5 allocations: 256 bytes)
        # 109.885 ns (5 allocations: 256 bytes)
        # 216.325 ns (9 allocations: 440 bytes)
        # 110.618 ns (5 allocations: 248 bytes)
        # 111.141 ns (5 allocations: 248 bytes)
        # 220.643 ns (9 allocations: 432 bytes)
        @btime BioLab.String.count($n, $si)

    end

end
