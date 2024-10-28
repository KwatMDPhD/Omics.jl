using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

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

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for uc in (-2, -1, 0, 1, 2)

        @test Omics.Strin.coun(uc, si) === "$uc $(1 < abs(uc) ? pl : si)"

    end

end

# ---- #

@test Omics.Strin.shorten(pi) === "3.1"

# ---- #

Omics.Strin.date("2024 10 28")
