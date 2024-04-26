using Test: @test

using Nucleus

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

    @test Nucleus.String.is_bad(ba)

    @test Nucleus.String.is_bad(ba^2)

    @test !Nucleus.String.is_bad("A$ba")

    @test !Nucleus.String.is_bad("$(ba)B")

    @test !Nucleus.String.is_bad("A$(ba)B")

    # 1.791 ns (0 allocations: 0 bytes)
    # 38.096 ns (0 allocations: 0 bytes)
    # 38.096 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.257 ns (0 allocations: 0 bytes)
    # 37.261 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.172 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.261 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.261 ns (0 allocations: 0 bytes)
    # 37.172 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    # 37.466 ns (0 allocations: 0 bytes)
    # 37.424 ns (0 allocations: 0 bytes)
    # 37.424 ns (0 allocations: 0 bytes)
    # 37.298 ns (0 allocations: 0 bytes)
    # 37.466 ns (0 allocations: 0 bytes)
    # 37.256 ns (0 allocations: 0 bytes)
    #@btime Nucleus.String.is_bad($ba)

end

# ---- #

for (st, re) in (("A_b.C-d+E!f%G%h]IjK", "A_b.C_d_E_f_G_h_IjK"),)

    @test Nucleus.String.clean(st) === re

    # 314.233 ns (3 allocations: 168 bytes)
    #@btime Nucleus.String.clean($st)

end

# ---- #

for (id, re) in ((1, "a"), (2, "b"), (3, "c"), (26, "z"))

    st = "a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z"

    @test Nucleus.String.split_get(st, '.', id) == re

    # 648.485 ns (3 allocations: 1.25 KiB)
    # 76.768 ns (2 allocations: 272 bytes)
    # 648.878 ns (3 allocations: 1.25 KiB)
    # 100.636 ns (2 allocations: 272 bytes)
    # 648.560 ns (3 allocations: 1.25 KiB)
    # 122.311 ns (2 allocations: 272 bytes)
    # 648.372 ns (3 allocations: 1.25 KiB)
    # 649.140 ns (3 allocations: 1.25 KiB)

    #@btime split($st, '.')[$id]

    #@btime Nucleus.String.split_get($st, '.', $id)

end

# ---- #

for (st, re) in (
    ("vertex", "vertices"),
    ("edge", "edges"),
    ("sex", "sexes"),
    ("country", "countries"),
    ("hero", "heroes"),
)

    for uc in (-2, 2, -1, 1, 0)

        if abs(uc) <= 1

            r2 = st

        else

            r2 = re

        end

        @test Nucleus.String.count(uc, st) === "$uc $r2"

        # 190.422 ns (6 allocations: 272 bytes)
        # 188.643 ns (6 allocations: 272 bytes)
        # 135.452 ns (5 allocations: 248 bytes)
        # 135.631 ns (5 allocations: 248 bytes)
        # 136.207 ns (5 allocations: 248 bytes)
        # 174.908 ns (5 allocations: 248 bytes)
        # 175.657 ns (5 allocations: 240 bytes)
        # 138.213 ns (5 allocations: 240 bytes)
        # 137.591 ns (5 allocations: 240 bytes)
        # 136.985 ns (5 allocations: 240 bytes)
        # 181.295 ns (6 allocations: 272 bytes)
        # 182.512 ns (6 allocations: 264 bytes)
        # 137.727 ns (5 allocations: 240 bytes)
        # 136.967 ns (5 allocations: 240 bytes)
        # 136.390 ns (5 allocations: 240 bytes)
        # 199.128 ns (6 allocations: 272 bytes)
        # 198.815 ns (6 allocations: 272 bytes)
        # 137.591 ns (5 allocations: 248 bytes)
        # 137.213 ns (5 allocations: 248 bytes)
        # 136.302 ns (5 allocations: 248 bytes)
        # 195.317 ns (6 allocations: 272 bytes)
        # 195.687 ns (6 allocations: 272 bytes)
        # 138.407 ns (5 allocations: 240 bytes)
        # 137.543 ns (5 allocations: 240 bytes)
        # 137.015 ns (5 allocations: 240 bytes)
        #@btime Nucleus.String.count($uc, $st)

    end

end
