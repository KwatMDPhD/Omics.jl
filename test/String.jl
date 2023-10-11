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
    @btime BioLab.String.limit($STL, $n)

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
    @btime BioLab.String.split_get($STS, $DE, $id)

end

# ---- #

@test BioLab.Error.@is BioLab.String.count(-1, "Car")

# ---- #

for (st, re) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for (n, re) in ((0, "0 $st"), (1, "1 $st"), (2, "2 $re"))

        @test BioLab.String.count(n, st) === re

        # 107.608 ns (5 allocations: 248 bytes)
        # 108.737 ns (5 allocations: 248 bytes)
        # 216.267 ns (9 allocations: 440 bytes)
        # 106.441 ns (5 allocations: 248 bytes)
        # 106.938 ns (5 allocations: 248 bytes)
        # 201.341 ns (8 allocations: 408 bytes)
        # 105.837 ns (5 allocations: 248 bytes)
        # 106.620 ns (5 allocations: 248 bytes)
        # 134.434 ns (5 allocations: 248 bytes)
        # 106.263 ns (5 allocations: 256 bytes)
        # 106.323 ns (5 allocations: 256 bytes)
        # 224.372 ns (9 allocations: 440 bytes)
        # 106.441 ns (5 allocations: 248 bytes)
        # 106.894 ns (5 allocations: 248 bytes)
        # 227.280 ns (9 allocations: 432 bytes)
        @btime BioLab.String.count($n, $st)

    end

end
