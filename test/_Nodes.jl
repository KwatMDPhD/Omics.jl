using PGMs

using PGMs.Nodes: @node

using Test: @test

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
