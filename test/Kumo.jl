using Test: @test

using Omics.Kumo: <<, >>, @st, Omics

# ---- #

function test_collection(no_, cl___, ed_)

    @test Tuple(Omics.Kumo.NO_) == no_

    @test Omics.Kumo.CL___ == cl___

    @test Tuple(Omics.Kumo.ED_) == ed_

    Omics.Kumo.plot("")

end

# ---- #

Omics.Kumo._add_node!("Luffy")

test_collection(("Luffy",), fill((), 1), ())

# ---- #

Omics.Kumo._add_node!("Zoro")

test_collection(("Luffy", "Zoro"), fill((), 2), ())

# ---- #

for _ in 1:2

    Omics.Kumo._add_node!("Nami")

end

test_collection(("Luffy", "Zoro", "Nami"), fill((), 3), ())

# ---- #

@test try

    Omics.Kumo._add_edge!("BigMama", "Luffy")

catch

    true

end

# ---- #

for _ in 1:2

    Omics.Kumo._add_edge!("Nami", "Nami")

end

test_collection(("Luffy", "Zoro", "Nami"), fill((), 3), (("Nami", "Nami"),))

# ---- #

Omics.Kumo._add_edge!("Zoro", "Nami")

test_collection(
    ("Luffy", "Zoro", "Nami"),
    fill((), 3),
    (("Nami", "Nami"), ("Zoro", "Nami")),
)

# ---- #

Omics.Kumo._add_node!("Crew")

Omics.Kumo._add_edge!(("Luffy", "Zoro", "Nami"), "Crew")

test_collection(
    ("Luffy", "Zoro", "Nami", "Crew"),
    fill((), 4),
    (
        ("Nami", "Nami"),
        ("Zoro", "Nami"),
        ("Luffy", "Crew"),
        ("Zoro", "Crew"),
        ("Nami", "Crew"),
    ),
)

# ---- #

for an in ("和道一文字", "三代鬼徹", "閻魔")

    Omics.Kumo._add_node!(an)

end

Omics.Kumo._add_edge!("Zoro", ("和道一文字", "三代鬼徹", "閻魔"))

test_collection(
    ("Luffy", "Zoro", "Nami", "Crew", "和道一文字", "三代鬼徹", "閻魔"),
    fill((), 7),
    (
        ("Nami", "Nami"),
        ("Zoro", "Nami"),
        ("Luffy", "Crew"),
        ("Zoro", "Crew"),
        ("Nami", "Crew"),
        ("Zoro", "和道一文字"),
        ("Zoro", "三代鬼徹"),
        ("Zoro", "閻魔"),
    ),
)

# ---- #

for an in ("Sanji", "Respect", "Competitiveness")

    Omics.Kumo._add_node!(an)

end

Omics.Kumo._add_edge!(("Zoro", "Sanji"), ("Respect", "Competitiveness"))

test_collection(
    (
        "Luffy",
        "Zoro",
        "Nami",
        "Crew",
        "和道一文字",
        "三代鬼徹",
        "閻魔",
        "Sanji",
        "Respect",
        "Competitiveness",
    ),
    fill((), 10),
    (
        ("Nami", "Nami"),
        ("Zoro", "Nami"),
        ("Luffy", "Crew"),
        ("Zoro", "Crew"),
        ("Nami", "Crew"),
        ("Zoro", "和道一文字"),
        ("Zoro", "三代鬼徹"),
        ("Zoro", "閻魔"),
        ("Zoro", "Respect"),
        ("Zoro", "Competitiveness"),
        ("Sanji", "Respect"),
        ("Sanji", "Competitiveness"),
    ),
)

# ---- #

Omics.Kumo.clear!()

test_collection((), [], ())

# ---- #

for (an, ho, re) in (("A", "de", "A.de"), (("A", "B"), "in", "A_B.in"))

    @test Omics.Kumo._make_how_node(an, ho) === re

end

# ---- #

for an in ("Ka", "Kw", "Ay", "Zo", "Distraction", "Complexity", "Bad")

    Omics.Kumo._add_node!(an)

end

for (a1, ho, a2) in (
    ("Ka", "de", "Distraction"),
    ("Kw", "de", ("Bad", "Complexity")),
    (("Ka", "Kw"), "in", "Ay"),
    (("Ka", "Kw"), "in", ("Ay", "Zo")),
)

    Omics.Kumo._add_edge!(a1, ho, a2)

end

test_collection(
    (
        "Ka",
        "Kw",
        "Ay",
        "Zo",
        "Distraction",
        "Complexity",
        "Bad",
        "Ka.de",
        "Kw.de",
        "Ka_Kw.in",
    ),
    fill((), 10),
    (
        ("Ka", "Ka.de"),
        ("Ka.de", "Distraction"),
        ("Kw", "Kw.de"),
        ("Kw.de", "Bad"),
        ("Kw.de", "Complexity"),
        ("Ka", "Ka_Kw.in"),
        ("Kw", "Ka_Kw.in"),
        ("Ka_Kw.in", "Ay"),
        ("Ka_Kw.in", "Zo"),
    ),
)

# ---- #

Omics.Kumo.clear!()

@macroexpand @st Node

@st Node

test_collection(("Node",), fill((), 1), ())

# ---- #

Omics.Kumo.clear!()

@macroexpand @st NodeWithClass Class1 Class2

@st NodeWithClass Class1 Class2

test_collection(("NodeWithClass",), [("Class1", "Class2")], ())

# ---- #

function clear_st(an_)

    Omics.Kumo.clear!()

    for an in an_

        eval(:(@st $(Symbol(an))))

    end

end

# ---- #

clear_st('A':'Z')

A << A

B << C

(D, E) << F

G << (H, I)

(J, K) << (L, M)

N >> N

O >> P

(Q, R) >> S

T >> (U, V)

(W, X) >> (Y, Z)

Omics.Kumo.plot("")

# ---- #

const FE_ = "Ligand", "GPCR", "GPCRLigand", "GP", "GPCRGP", "GOn", "GPCRDone", "Arrestin"

const UF = lastindex(FE_)

clear_st(FE_)

(Ligand, GPCR) >> GPCRLigand

(GPCRLigand, GP) >> GPCRGP

GPCRGP >> (GOn, GPCRDone)

Arrestin << GPCRDone

test_collection(
    (FE_..., "Ligand_GPCR.in", "GPCRLigand_GP.in", "GPCRGP.in", "Arrestin.de"),
    fill((), UF + 4),
    (
        ("Ligand", "Ligand_GPCR.in"),
        ("GPCR", "Ligand_GPCR.in"),
        ("Ligand_GPCR.in", "GPCRLigand"),
        ("GPCRLigand", "GPCRLigand_GP.in"),
        ("GP", "GPCRLigand_GP.in"),
        ("GPCRLigand_GP.in", "GPCRGP"),
        ("GPCRGP", "GPCRGP.in"),
        ("GPCRGP.in", "GOn"),
        ("GPCRGP.in", "GPCRDone"),
        ("Arrestin", "Arrestin.de"),
        ("Arrestin.de", "GPCRDone"),
    ),
)

# ---- #

const EP_ =
    Omics.Cytoscape.rea(Omics.Kumo.plot("$(joinpath(tempdir(), "GPCR")).html"; ex = "json"))

# ---- #

# 958.294 ns (7 allocations: 688 bytes)

const SC_ = range(0, 1, UF)

const HE_ = Omics.Kumo.heat(FE_, SC_)

@test HE_ == vcat(SC_, zeros(4))

#@btime Omics.Kumo.heat(FE_, SC_);

Omics.Kumo.plot(""; ep_ = EP_, he_ = HE_)

# ---- #

#  521.698 ns (7 allocations: 848 bytes)

const ED = Omics.Kumo.make_edge_matrix()

@test sum(ED) === length(Omics.Kumo.ED_)

#@btime Omics.Kumo.make_edge_matrix();

# ---- #

# 10.875 μs (557 allocations: 114.80 KiB)

const HI = Omics.Kumo.play(HE_, ED)

@test size(HI, 2) === 30

@test map(sum, eachcol(HI)) == [
    4.0,
    3.928571428571428,
    4.361807614080452,
    4.841196736243137,
    5.204461981358573,
    5.451465133897608,
    5.611092068362889,
    5.711520312695818,
    5.7737610249366345,
    5.812000433388874,
    5.835373519146523,
    5.849616124665676,
    5.858279022978179,
    5.863542283746393,
    5.866737904314711,
    5.868677357056958,
    5.869854140070007,
    5.870568058923495,
    5.871001132883382,
    5.871263827696215,
    5.871423168313263,
    5.871519816284339,
    5.871578437346185,
    5.871613993223707,
    5.871635559102994,
    5.871648639524959,
    5.871656573222147,
    5.871661385260175,
    5.871664303911514,
    5.871666074164041,
]

@test HI[:, end] == [
    0.0,
    0.14285714285714285,
    0.2857142857142857,
    0.42857142857142855,
    1.1219617145500707,
    1.7894690854152187,
    0.62398814233751,
    1.0,
    0.0,
    0.3571428571428571,
    1.1219614175755281,
    -1.0,
]

#@btime Omics.Kumo.play(HE_, ED);

# ---- #

for pe in (0, 0.5, 8)

    Omics.Kumo.animate(joinpath(homedir(), "Downloads", "animate_$pe"), EP_, HI; pe)

end
