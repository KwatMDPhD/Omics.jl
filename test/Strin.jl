using Dates: Date

using Test: @test

using Omics

# ---- #

for st in (
    "",
    " ",
    "α",
    "π",
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

    @test Omics.Strin.is_bad(st)

    @test Omics.Strin.is_bad(st^2)

    @test !Omics.Strin.is_bad("a$st")

    @test !Omics.Strin.is_bad("$(st)b")

    @test !Omics.Strin.is_bad("a$(st)b")

end

# ---- #

for (st, re) in (("a/b", "a_b"),)

    @test Omics.Strin.slash(st) === re

end

# ---- #

const S1 = " less  is   more    "

const S2 = "    DNA   RNA  protein "

# ---- #

for (st, re) in ((S1, "_less__is___more____"), (S2, "____dna___rna__protein_"))

    @test Omics.Strin.lower(st) === re

end

# ---- #

for (st, re) in (
    ("i'M", "I'm"),
    ("you'RE", "You're"),
    ("it'S", "It's"),
    ("we'VE", "We've"),
    ("i'D", "I'd"),
    ("1ST", "1st"),
    ("2ND", "2nd"),
    ("3RD", "3rd"),
    ("4TH", "4th"),
    (S1, " Less  Is   More    "),
    (S2, "    DNA   RNA  Protein "),
)

    @test Omics.Strin.title(st) === re

end

# ---- #

for (st, re) in ((" a  b   ", "a b"),)

    @test Omics.Strin.stri(st) === re

end

# ---- #

const S3 = "1234567890"

for (nu, re) in ((1, "1..."), (2, "12..."), (11, S3))

    @test Omics.Strin.limit(S3, nu) === re

end

# ---- #

# 45.328 ns (2 allocations: 256 bytes)
# 429.226 ns (3 allocations: 1.23 KiB)
# 63.776 ns (2 allocations: 256 bytes)
# 428.603 ns (3 allocations: 1.23 KiB)
# 77.418 ns (2 allocations: 256 bytes)
# 429.226 ns (3 allocations: 1.23 KiB)
# 429.020 ns (3 allocations: 1.23 KiB)
# 429.231 ns (3 allocations: 1.23 KiB)

const S4 = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

for (id, re) in ((1, "a"), (2, "b"), (3, "c"), (26, "z"))

    @test Omics.Strin.ge(S4, id, '.') == re

    #@btime Omics.Strin.ge(S4, $id, '.')

    #@btime split(S4, '.')[$id]

end

# ---- #

const S5 = "a b c"

# ---- #

for (st, re) in ((S5, "a"),)

    @test Omics.Strin.get_1(st) == re

end

# ---- #

for (st, re) in ((S5, "c"),)

    @test Omics.Strin.get_end(st) == re

end

# ---- #

for (st, re) in ((S5, "b c"),)

    @test Omics.Strin.trim_1(st) == re

end

# ---- #

for (st, re) in ((S5, "a b"),)

    @test Omics.Strin.trim_end(st) == re

end

# ---- #

# 119.223 ns (6 allocations: 200 bytes)
# 123.934 ns (6 allocations: 200 bytes)
# 117.495 ns (6 allocations: 208 bytes)
# 134.666 ns (7 allocations: 240 bytes)
# 130.471 ns (7 allocations: 232 bytes)
# 139.032 ns (7 allocations: 232 bytes)
# 139.857 ns (7 allocations: 240 bytes)
# 126.902 ns (6 allocations: 200 bytes)

for (si, pl) in (
    ("sex", "sexes"),
    ("bus", "buses"),
    ("hero", "heroes"),
    ("country", "countries"),
    ("city", "cities"),
    ("index", "indices"),
    ("vertex", "vertices"),
    ("edge", "edges"),
)

    for nu in (-2, -1, 0, 1, 2)

        @test Omics.Strin.coun(nu, si) === "$nu $(1 < abs(nu) ? pl : si)"

    end

    #@btime Omics.Strin.coun(2, $si)

end

# ---- #

for (st_, re) in ((('A', "Bb", "Cc"), "A · Bb · Cc"),)

    @test Omics.Strin.chain(st_) === re

end

# ---- #

for (st, re) in (("2024 10 28", Date("2024-10-28")),)

    @test Omics.Strin.date("2024 10 28") === re

end
