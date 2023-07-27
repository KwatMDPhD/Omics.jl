using Test: @test

using BioLab

using BioLab.Kumo: @st, <<, >>

# ---- #

@test Kumo.NO_ isa Vector{String} && isempty(Kumo.NO_)

# ---- #

@test Kumo.NO_CL_ isa Dict{String, Tuple} && isempty(Kumo.NO_CL_)

# ---- #

@test Kumo.ED_ isa Vector{Tuple{String, String}} && isempty(Kumo.ED_)

# ---- #

Kumo._add!("Luffy")

@test Kumo.NO_ == ["Luffy"]

Kumo._add!("Zoro")

@test Kumo.NO_ == ["Luffy", "Zoro"]

Kumo._add!("Nami")

Kumo._add!("Nami")

@test Kumo.NO_ == ["Luffy", "Zoro", "Nami"]

# no = "Node"

# ---- #

@test BioLab.@is_error Kumo._add!("Kaido", "BigMaMa")

Kumo._add!("Luffy", "Nami")

@test Kumo.ED_ == [("Luffy", "Nami")]

Kumo._add!("Zoro", "Nami")

@test Kumo.ED_ == [("Luffy", "Nami"), ("Zoro", "Nami")]

# so = "Source"

# ta = "Target"

# ---- #

Kumo._add!("Crew")

Kumo._add!(("Luffy", "Zoro", "Nami"), "Crew")

@test Kumo.ED_ ==
      [("Luffy", "Nami"), ("Zoro", "Nami"), ("Luffy", "Crew"), ("Zoro", "Crew"), ("Nami", "Crew")]

# so_ = ("Source1", "Source2")

# ta = "Target"

# ---- #

Kumo._add!("和道一文字")

Kumo._add!("三代鬼徹")

Kumo._add!("閻魔")

Kumo._add!("Zoro", ("和道一文字", "三代鬼徹", "閻魔"))

@test Kumo.ED_ == [
    ("Luffy", "Nami"),
    ("Zoro", "Nami"),
    ("Luffy", "Crew"),
    ("Zoro", "Crew"),
    ("Nami", "Crew"),
    ("Zoro", "和道一文字"),
    ("Zoro", "三代鬼徹"),
    ("Zoro", "閻魔"),
]

# so = "Source"

# ta_ = ("Target1", "Target2")

# ---- #

# TODO: Implement show.
Kumo.print()

# ---- #

Kumo.plot()

# ---- #

Kumo.clear!()

@test Kumo.NO_ isa Vector{String} && isempty(Kumo.NO_)

@test Kumo.NO_CL_ isa Dict{String, Tuple} && isempty(Kumo.NO_CL_)

@test Kumo.ED_ isa Vector{Tuple{String, String}} && isempty(Kumo.ED_)

# ---- #

for ((so, ho), re) in ((("Ka", "de"), "Ka.de"), ((("Ka", "Kw"), "in"), "Ka_Kw.in"))

    @test Kumo._make_how_node(so, ho) == re

end

# ---- #

for no in ("Ka", "Kw", "Anxiety", "Ay", "Zo", "Code", "Complexity")

    Kumo._add!(no)

end

for (so, ho, ta) in (
    ("Ka", "de", "Anxiety"),
    (("Ka", "Kw"), "in", "Ay"),
    ("Kw", "de", ("Code", "Complexity")),
    (("Ka", "Kw"), "in", ("Ay", "Zo")),
)

    Kumo._add!(so, ho, ta)

end

@test Kumo.ED_ == [
    ("Ka", "Ka.de"),
    ("Ka.de", "Anxiety"),
    ("Ka", "Ka_Kw.in"),
    ("Kw", "Ka_Kw.in"),
    ("Ka_Kw.in", "Ay"),
    ("Kw", "Kw.de"),
    ("Kw.de", "Code"),
    ("Kw.de", "Complexity"),
    ("Ka_Kw.in", "Zo"),
]

Kumo.plot()

Kumo.clear!()

# ---- #

@macroexpand @st Node

@st Node

@test Kumo.NO_ == ["Node"]

# ---- #

@macroexpand @st _2Guns DEA Navy

@st _2Guns DEA Navy

@test Kumo.NO_ == ["Node", "_2Guns"]

@test Kumo.NO_CL_ == Dict("_2Guns" => ("DEA", "Navy"))

# ---- #

function az()

    Kumo.clear!()

    for ch in 'A':'Z'

        eval(:(@st $(Symbol(ch))))

    end

end

# ---- #

az()

A << B

(C, D) << E

F << (G, H)

(I, J) << (K, L)

Kumo.plot()

# ---- #

az()

A >> B

(C, D) >> E

F >> (G, H)

(I, J) >> (K, L)

Kumo.plot()

# ---- #

Kumo.clear!()

no_ = ("Ligand", "GPCR", "GPCRLigand", "GP", "GPCRGP", "GOn", "GPCRDone", "Arrestin")

for no in no_

    eval(:(@st $(Symbol(no))))

end

(Ligand, GPCR) >> GPCRLigand

(GPCRLigand, GP) >> GPCRGP

GPCRGP >> (GOn, GPCRDone)

Arrestin << GPCRDone

# ---- #

pr = "Kumo.GPCR"

js = joinpath(homedir(), "Downloads", "$pr.json")

if ispath(js)

    rm(js)

end

te = joinpath(tempdir(), "Kumo.test")

BioLab.Path.empty(te)

Kumo.plot(; ht = joinpath(te, "$pr.html"), wr = "json")

while !ispath(js)

end

# ---- #

fe_sc = Dict(no => 1 for no in no_)

fe_sc["Other feature"] = 0

he_ = Kumo.heat(fe_sc)

re = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0]

@test he_ == re

# 477.349 ns (5 allocations: 672 bytes)
#@btime Kumo.heat($fe_sc);

# ---- #

fe_x_sa_x_sc = repeat([1 10], length(no_) + 1)

no_x_sa_x_he = Kumo.heat(no_, fe_x_sa_x_sc)

re = hcat(re, re * 10)

@test no_x_sa_x_he == re

# 1.413 μs (15 allocations: 2.09 KiB)
#@btime Kumo.heat($no_, $fe_x_sa_x_sc);

# ---- #

so_x_ta_x_ed = Kumo.make_edge_matrix()

@test sum(so_x_ta_x_ed) == length(Kumo.ED_)

# 1.200 μs (15 allocations: 3.73 KiB)
#@btime Kumo.make_edge_matrix();

# ---- #

he___ = Kumo.anneal(he_)

@test all(length(he_) == 12 for he_ in he___)

# 43.541 μs (939 allocations: 92.45 KiB)
#@btime Kumo.anneal($he_);

# ---- #

no_x_sa_x_an = Kumo.anneal(no_x_sa_x_he)

@test size(no_x_sa_x_an) == size(no_x_sa_x_he)

# 92.958 μs (2006 allocations: 195.16 KiB)
#@btime Kumo.anneal($no_x_sa_x_he);

# ---- #

for pe in (0, 0.5, 1)

    Kumo.animate(js, he___, mkdir(joinpath(te, "animate.$pe")); pe)

end
