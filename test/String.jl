include("environment.jl")

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

    @test BioLab.String.try_parse(st) == re

end

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

    @test isequal(BioLab.String.format(nu), re)

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

for (n, re) in ((0, "..."), (1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    @test BioLab.String.limit("Can", n) == re

end

# ---- #

st = join('a':'z', '.')

de = '.'

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    @test BioLab.String.split_get(st, de, id) == re

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

# ---- #

for (si, pl) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for (n, re) in ((-1, "-1 $si"), (0, "0 $si"), (1, "1 $si"), (2, "2 $pl"))

        @test BioLab.String.count(n, si) == re

    end

end
