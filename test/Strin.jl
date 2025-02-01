using Dates: Date

using Test: @test

using Omics

# ---- #

for st in (
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

    @test Omics.Strin.is_bad(st)

    @test Omics.Strin.is_bad(st^2)

    @test !Omics.Strin.is_bad("A$st")

    @test !Omics.Strin.is_bad("$(st)B")

    @test !Omics.Strin.is_bad("A$(st)B")

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
    (S1, " Less  Is   More    "),
    (S2, "    DNA   RNA  Protein "),
    ("i'm on the path", "I'm on the Path"),
    ("i'M ON THE path", "I'M ON THE Path"),
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

for (st, re) in ((" a  b   ", "a b"),)

    @test Omics.Strin.stri(st) === re

end

# ---- #

const LO = "1234567890"

for (uc, re) in ((1, "1..."), (2, "12..."), (11, LO))

    @test Omics.Strin.limit(LO, uc) === re

end

# ---- #

for (id, re) in ((1, "a"), (2, "b"), (3, "c"), (26, "z"))

    @test Omics.Strin.ge("a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z", id, '.') ==
          re

end

# ---- #

const ST = "a b c"

# ---- #

for (st, re) in ((ST, "a"),)

    @test Omics.Strin.get_1(st) == re

end

# ---- #

for (st, re) in ((ST, "c"),)

    @test Omics.Strin.get_end(st) == re

end

# ---- #

for (st, re) in ((ST, "b c"),)

    @test Omics.Strin.trim_1(st) == re

end

# ---- #

for (st, re) in ((ST, "a b"),)

    @test Omics.Strin.trim_end(st) == re

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

for (st_, re) in ((('A', "Bb", "Cc"), "A · Bb · Cc"),)

    @test Omics.Strin.chain(st_) === re

end

# ---- #

for (st, re) in (("2024 10 28", Date("2024-10-28")),)

    @test Omics.Strin.date("2024 10 28") === re

end
