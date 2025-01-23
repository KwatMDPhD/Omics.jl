using Test: @test

using Omics

# ---- #

for ba in (
    "",
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

    @test Omics.Strin.is_bad(ba)

    @test Omics.Strin.is_bad(ba^2)

    @test !Omics.Strin.is_bad("A$ba")

    @test !Omics.Strin.is_bad("$(ba)B")

    @test !Omics.Strin.is_bad("A$(ba)B")

end

# ---- #

for (st, re) in (
    (" less  is   more    ", "_less__is___more____"),
    ("    DNA   RNA  protein ", "____dna___rna__protein_"),
    ("i'm on the path", "i_m_on_the_path"),
)

    @test Omics.Strin.lower(st) === re

end

# ---- #

for (st, re) in (
    (" less  is   more    ", "Less Is More"),
    ("    DNA   RNA  protein ", "DNA RNA Protein"),
    ("i'm on a path", "I'm on a Path"),
    ("i'M ON A path", "I'M ON A Path"),
    ("1st", "1st"),
    ("1ST", "1ST"),
    ("2nd", "2nd"),
    ("2Nd", "2Nd"),
    ("3rd", "3rd"),
    ("3rD", "3rD"),
    ("4th", "4th"),
    ("5TH", "5TH"),
)

    @test Omics.Strin.title(st) === re

end

# ---- #

const LO = "1234567890"

for (uc, re) in ((1, "1..."), (2, "12..."), (11, LO))

    @test Omics.Strin.limit(LO, uc) === re

end

# ---- #

const ST = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

# 433.211 ns (3 allocations: 1.23 KiB)
# 44.862 ns (2 allocations: 256 bytes)
# 433.839 ns (3 allocations: 1.23 KiB)
# 63.776 ns (2 allocations: 256 bytes)
# 430.487 ns (3 allocations: 1.23 KiB)
# 77.276 ns (2 allocations: 256 bytes)
# 430.065 ns (3 allocations: 1.23 KiB)
# 430.065 ns (3 allocations: 1.23 KiB)
for (id, re) in ((1, "a"), (2, "b"), (3, "c"), (26, "z"))

    @test Omics.Strin.split_get(ST, '.', id) == re

    #@btime split(ST, '.')[$id]

    #@btime Omics.Strin.split_get(ST, '.', $id)

end

# ---- #

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for us in (-2, -1, 0, 1, 2)

        @test Omics.Strin.coun(us, si) === "$us $(1 < abs(us) ? pl : si)"

    end

end

# ---- #

@test Omics.Strin.chain(('A', "Bb", "Cc")) === "A · Bb · Cc"

# ---- #

Omics.Strin.date("2024 10 28")

# ---- #

@test Omics.Strin.shorten(pi) === "3.1"
