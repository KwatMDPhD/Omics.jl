include("_.jl")

# ----------------------------------------------------------------------------------------------- #

st = "Can"

for (n, re) in ((1, "C..."), (2, "Ca..."), (3, "Can"), (4, "Can"))

    BioLab.print_header(n)

    @test BioLab.String.limit(st, n) == re

    # @code_warntype BioLab.String.limit(st, n)

    # 40.616 ns (2 allocations: 48 bytes)
    # 40.657 ns (2 allocations: 48 bytes)
    # 6.708 ns (0 allocations: 0 bytes)
    # 6.750 ns (0 allocations: 0 bytes)
    # @btime BioLab.String.limit($st, $n)

end

# ----------------------------------------------------------------------------------------------- #

for (no, re) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    BioLab.print_header(no)

    @test BioLab.String.count_noun(1, no) == "1 $no"

    n = 2

    @test BioLab.String.count_noun(n, no) == "$n $re"

    # @code_warntype BioLab.String.count_noun(n, no)

    # 1.762 μs (12 allocations: 560 bytes)
    # 4.554 μs (11 allocations: 416 bytes)
    # 144.806 ns (6 allocations: 272 bytes)
    # 3.172 μs (14 allocations: 656 bytes)
    # 4.548 μs (16 allocations: 664 bytes)
    # @btime BioLab.String.count_noun($n, $no)

end

# ----------------------------------------------------------------------------------------------- #

for (st, re) in (
    ("aa", "Aa"),
    ("DNA", "DNA"),
    ("Hello world!", "Hello World!"),
    ("SARS-COVID-2", "SARS-COVID-2"),
    ("This is an apple", "This Is an Apple"),
    ("i'm a man", "I'm a Man"),
)

    BioLab.print_header(st)

    @test BioLab.String.title(st) == re

    # @code_warntype BioLab.String.title(st)

    # 4.476 μs (215 allocations: 11.55 KiB)
    # 4.661 μs (218 allocations: 11.64 KiB)
    # 5.611 μs (245 allocations: 12.46 KiB)
    # 5.681 μs (245 allocations: 12.46 KiB)
    # 6.242 μs (265 allocations: 13.33 KiB)
    # 5.590 μs (252 allocations: 13.12 KiB)
    # @btime BioLab.String.title($st)

end

# ----------------------------------------------------------------------------------------------- #

st = join('a':'z', '.')

de = '.'

for (id, re) in ((1, "a"), (16, "p"), (26, "z"))

    BioLab.print_header(id)

    @test BioLab.String.split_and_get(st, de, id) == re

    # @code_warntype BioLab.String.split_and_get(st, de, id)

    # 76.260 ns (2 allocations: 272 bytes)
    # 404.375 ns (3 allocations: 1.25 KiB)
    # 586.785 ns (3 allocations: 1.25 KiB)
    # @btime BioLab.String.split_and_get($st, $de, $id)

end

# ----------------------------------------------------------------------------------------------- #

for (st_, re) in (
    [("", "", ""), ["", "", ""]],
    [("kate",), [""]],
    [("kate", "katana"), ["e", "ana"]],
    [("kate", "kwat"), ["ate", "wat"]],
    [("kate", "kwat", "kazakh"), ["ate", "wat", "azakh"]],
    [("a", "ab", "abc"), ["", "b", "bc"]],
    [("abc", "ab", "a"), ["bc", "b", ""]],
)

    BioLab.print_header(st_)

    @test BioLab.String.remove_common_prefix(st_) == re

    # @code_warntype BioLab.String.remove_common_prefix(st_)

    # 265.106 ns (7 allocations: 304 bytes)
    # 1.163 μs (20 allocations: 584 bytes)
    # 1.283 μs (22 allocations: 792 bytes)
    # 799.638 ns (16 allocations: 568 bytes)
    # 857.246 ns (17 allocations: 624 bytes)
    # 612.310 ns (13 allocations: 488 bytes)
    # 613.023 ns (13 allocations: 488 bytes)
    # @btime BioLab.String.remove_common_prefix($st_)

end

# ----------------------------------------------------------------------------------------------- #

st1 = "A--BB--CCC"

de = "--"

id_ = (1, 2, 1)

@test @is_error BioLab.String.transplant(st1, "a--bb", de, id_)

st2 = "a--bb--ccc"

@test BioLab.String.transplant(st1, st2, de, id_) == "A--bb--CCC"

# @code_warntype BioLab.String.transplant(st1, st2, de, id_)

# 474.913 ns (24 allocations: 1.73 KiB)
# @btime BioLab.String.transplant($st1, $st2, $de, $id_)
