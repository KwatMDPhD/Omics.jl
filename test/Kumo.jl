using Test

using BioLab

using Kumo: Kumo, @st, <<, >>

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

# @code_warntype Kumo._add!(no)

# ---- #

@test BioLab.@is_error Kumo._add!("Kaido", "BigMaMa")

Kumo._add!("Luffy", "Nami")

@test Kumo.ED_ == [("Luffy", "Nami")]

Kumo._add!("Zoro", "Nami")

@test Kumo.ED_ == [("Luffy", "Nami"), ("Zoro", "Nami")]

# so = "Source"

# ta = "Target"

# @code_warntype Kumo._add!(so, ta)

# ---- #

Kumo._add!("Crew")

Kumo._add!(("Luffy", "Zoro", "Nami"), "Crew")

@test Kumo.ED_ ==
      [("Luffy", "Nami"), ("Zoro", "Nami"), ("Luffy", "Crew"), ("Zoro", "Crew"), ("Nami", "Crew")]

# so_ = ("Source1", "Source2")

# ta = "Target"

# @code_warntype Kumo._add!(so_, ta)

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

# @code_warntype Kumo._add!(so, ta_)

# ---- #

Kumo.print()

# @code_warntype Kumo.print()

# ---- #

Kumo.plot()

# @code_warntype Kumo.plot()

# ---- #

Kumo.clear!()

@test Kumo.NO_ isa Vector{String} && isempty(Kumo.NO_)

@test Kumo.NO_CL_ isa Dict{String, Tuple} && isempty(Kumo.NO_CL_)

@test Kumo.ED_ isa Vector{Tuple{String, String}} && isempty(Kumo.ED_)

# @code_warntype Kumo.clear!()

# ---- #

for ((so, ho), re) in ((("Ka", "de"), "Ka.de"), ((("Ka", "Kw"), "in"), "Ka_Kw.in"))

    BioLab.print_header()

    @test Kumo._make_how_node(so, ho) == re

    # @code_warntype Kumo._make_how_node(so, ho)

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

    BioLab.print_header()

    Kumo._add!(so, ho, ta)

    # @code_warntype Kumo._add!(so, ho, ta)

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

display(@macroexpand @st Node)

@st Node

@test Kumo.NO_ == ["Node"]

# @code_warntype @st Node

# ---- #

display(@macroexpand @st _2Guns DEA Navy)

@st _2Guns DEA Navy

@test Kumo.NO_ == ["Node", "_2Guns"]

@test Kumo.NO_CL_ == Dict("_2Guns" => ("DEA", "Navy"))

# @code_warntype @st _2Guns DEA Navy

# ---- #

function az()

    Kumo.clear!()

    for ch in 'A':'Z'

        eval(:(@st $(Symbol(ch))))

    end

    return nothing

end

# ---- #

az()

A << B

(C, D) << E

F << (G, H)

(I, J) << (K, L)

Kumo.plot()

# @code_warntype A << B

# ---- #

az()

A >> B

(C, D) >> E

F >> (G, H)

(I, J) >> (K, L)

Kumo.plot()

# @code_warntype A >> B

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

fe_sc = Dict(no => 1.0 for no in no_)

fe_sc["Other feature"] = 0.0

he_ = Kumo.heat(fe_sc)

re = [1.0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0.0]

@test he_ == re

# @code_warntype Kumo.heat(fe_sc)

# 477.349 ns (5 allocations: 672 bytes)
# @btime Kumo.heat($fe_sc)

# ---- #

fe_x_sa_x_sc = repeat([1.0 10], length(no_) + 1)

no_x_sa_x_he = Kumo.heat(no_, fe_x_sa_x_sc)

re = hcat(re, re * 10)

@test no_x_sa_x_he == re

# @code_warntype Kumo.heat(no_, fe_x_sa_x_sc)

# 1.413 μs (15 allocations: 2.09 KiB)
# @btime Kumo.heat($no_, $fe_x_sa_x_sc)

# ---- #

so_x_ta_x_ed = Kumo.make_edge_matrix()

display(so_x_ta_x_ed)

@test sum(so_x_ta_x_ed) == length(Kumo.ED_)

# @code_warntype Kumo.make_edge_matrix()

# 1.200 μs (15 allocations: 3.73 KiB)
# @btime Kumo.make_edge_matrix()

# ---- #

he___ = Kumo.anneal(he_)

@test all(length(he_) == 12 for he_ in he___)

# @code_warntype Kumo.anneal(he_)

# 43.541 μs (939 allocations: 92.45 KiB)
# @btime Kumo.anneal($he_; pr = false)

# ---- #

no_x_sa_x_an = Kumo.anneal(no_x_sa_x_he)

@test size(no_x_sa_x_an) == size(no_x_sa_x_he)

# @code_warntype Kumo.anneal(no_x_sa_x_he)

# 92.958 μs (2006 allocations: 195.16 KiB)
# @btime Kumo.anneal($no_x_sa_x_he; pr = false)

# ---- #

for pe in (0, 0.5, 1)

    di = mkpath(joinpath(te, "animate.$pe"))

    Kumo.animate(js, he___, di; pe)

    # @code_warntype Kumo.animate(js, he___, di; pe)

end
