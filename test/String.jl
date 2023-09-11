using Test: @test

using BioLab

# ---- #

for (nu, re) in (
    (-0, "0"),
    (0, "0"),
    (-0.0, "0"),
    (0.0, "0"),
    (1 / 3, "0.3333"),
    (1 / 2, "0.5"),
    (0.1234567890123456789, "0.1235"),
    (0.001, "0.001"),
    (0.000001, "1e-06"),
)

    @test BioLab.String.format(nu) === re

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

end

# ---- #

for (n, re) in ((0, "..."), (1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test BioLab.String.limit("Can", n) === re

end

# ---- #

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    @test BioLab.String.split_get(
        "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z",
        '.',
        id,
    ) == re

end

# ---- #

@test BioLab.String.dice("""
1\t2\t3
4\t5\t6""") == [["1", "2", "3"], ["4", "5", "6"]]

# ---- #

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for (n, re) in ((-1, "-1 $si"), (0, "0 $si"), (1, "1 $si"), (2, "2 $pl"))

        @test BioLab.String.count(n, si) === re

    end

end
