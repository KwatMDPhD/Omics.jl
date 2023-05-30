include("environment.jl")

# ---- #

st = "Can"

for (n, re) in ((1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test BioLab.String.limit(st, n) == re

end

# ---- #

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for (n, re) in ((-1, "-1 $si"), (0, "0 $si"), (1, "1 $si"), (2, "2 $pl"))

        @test BioLab.String.count_noun(n, si) == re

    end

end

# ---- #

for (st, re) in (
    ("aa", "Aa"),
    ("DNA", "DNA"),
    ("Hello world!", "Hello World!"),
    ("SARS-COVID-2", "SARS-COVID-2"),
    ("This is an apple", "This Is an Apple"),
    ("i'm a man", "I'm a Man"),
)

    @test BioLab.String.title(st) == re

end

# ---- #

st = join('a':'z', '.')

de = '.'

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    @test BioLab.String.split_get(st, de, id) == re

end

# ---- #

for (st_, re) in (
    [("", "", ""), ("", "", "")],
    [("kate",), ("",)],
    [("kate", "katana"), ("e", "ana")],
    [("kate", "kwat"), ("ate", "wat")],
    [("kate", "kwat", "kazakh"), ("ate", "wat", "azakh")],
    [("a", "ab", "abc"), ("", "b", "bc")],
    [("abc", "ab", "a"), ("bc", "b", "")],
)

    @test Tuple(BioLab.String.remove_common_prefix(st_)) == re

end

# ---- #

de = "--"

id_ = (1, 2, 1)

# ---- #

st1 = "A--BB--CCC"

@test @is_error BioLab.String.transplant(st1, "a--bb", de, id_)

# ---- #

st2 = "a--bb--ccc"

@test BioLab.String.transplant(st1, st2, de, id_) == "A--bb--CCC"
