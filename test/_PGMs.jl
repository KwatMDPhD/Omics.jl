using Test: @test

using Omics

# ---- #

@macroexpand @node CategoricalNode (:category1, :category2)

@node CategoricalNode (:category1, :category2)

@test hasmethod(PGMs.Nodes.get_values, Tuple{CategoricalNode})

# ---- #

foreach(id -> @info(CategoricalNode(id)), 0:2)

ca = CategoricalNode()

@test PGMs.Nodes.get_values(ca) == (:category1, :category2)

# ---- #

try

    PGMs.Nodes.set_index!(ca, 3)

catch er

    @test er isa DomainError

end

# ---- #

PGMs.Nodes.set_index!(ca, 2)

@test ca.index == 2

# ---- #

@macroexpand @node ContinuousNode range(0, 1, 8)

@node ContinuousNode range(0, 1, 8)

@test hasmethod(PGMs.Nodes.get_values, Tuple{ContinuousNode})

# ---- #

foreach(id -> @info(ContinuousNode(id)), 0:8)

co = ContinuousNode()

@test PGMs.Nodes.get_values(co) == range(0, 1, 8)

# ---- #

try

    PGMs.Nodes.set_index!(co, 9)

catch er

    @test er isa DomainError

end

# ---- #

PGMs.Nodes.set_index!(co, 8)

@test co.index == 8

# ---- #

using PGMs

using PGMs.Factors: @factor

using Test: @test

# ---- #

for ch in 'A':'C'

    eval(:(struct $(Symbol(ch)) end))

end

# ---- #

@macroexpand @factor function p!(a::A, c::B, b::C) end

@factor function p!(a::A, c::B, b::C) end

@test hasmethod(PGMs.Factors.p!, Tuple{A, B, C})

# ---- #

using PGMs

using Graphs: nv

using Test: @test

# ---- #

module NatureNurture

using PGMs
using PGMs.Nodes: @node, set_index!
using PGMs.Factors: @factor

@node Nature (:low, :high)

@node Nurture (:low, :medium, :high)

@node Person range(0, 1, 8)

@factor function p!(na::Nature)

    return set_index!(na, rand() < 0.9 ? 1 : 2)

end

@factor function p!(nu::Nurture)

    ra = rand()

    return set_index!(nu, if ra < 0.2

        1

    elseif 0.2 <= ra <= 0.8

        2

    elseif 0.8 < ra

        3

    end)

end

@factor function p!(pe::Person, na::Nature, nu::Nurture)

    id_ = na.index, nu.index

    return set_index!(pe, if id_ == (1, 1) || id_ == (1, 2)

        rand(1:2)

    elseif id_ == (2, 2)

        rand(3:6)

    elseif id_ == (2, 1) || id_ == (1, 3) || id_ == (2, 3)

        rand(7:8)

    end)

end

end

# ---- #

module Family

using PGMs
using PGMs.Nodes: @node, set_index!
using PGMs.Factors: @factor

@node Father (:category1, :category2)

@node Mother range(0, 1, 8)

@node Daughter (:odd, :even, :differ)

@node Son (:odd, :even, :differ)

@factor function p!(fa::Father)

    return set_index!(fa, rand() < 0.5 ? 1 : 2)

end

@factor function p!(mo::Mother)

    return set_index!(mo, rand(1:8))

end

@factor function p!(da::Daughter, fa::Father, mo::Mother)

    id_ = fa.index, mo.index

    return set_index!(da, if all(isodd, id_)

        1

    elseif all(iseven, id_)

        2

    else

        3

    end)

end

@factor function p!(so::Son, fa::Father, mo::Mother)

    id_ = fa.index, mo.index

    return set_index!(so, if all(isodd, id_)

        1

    elseif all(iseven, id_)

        2

    else

        3

    end)

end

end

# ---- #

gr = PGMs.Graphs.graph(NatureNurture)

@test nv(gr.gr) == lastindex(gr.no_) == length(gr.no_id) == 3

# ---- #

gr = PGMs.Graphs.graph(Family)

@test nv(gr.gr) == lastindex(gr.no_) == length(gr.no_id) == 4
