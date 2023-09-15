using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

@test isconst(BioLab, :_DA)

@test BioLab.Path.read(BioLab._DA) == [
    "CLS",
    "DataFrame",
    "Dict",
    "FeatureSetEnrichment",
    "GCT",
    "GMT",
    "Gene",
    "Plot",
    "SingleCell",
]

# ---- #

@test isconst(BioLab, :TE)

@test isempty(BioLab.Path.read(BioLab.TE))

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

const MO_ = filter!(!=("BioLab.jl"), BioLab.Path.read(SR))

for jl in MO_

    @test chop(jl; tail = 3) == chop(readline(joinpath(SR, jl)); head = 7, tail = 0)

end

# ---- #

const TE_ = filter!(!=("runtests.jl"), BioLab.Path.read(@__DIR__))

@test isempty(symdiff(MO_, TE_))

# ---- #

for jl in TE_

    @info "Testing $jl"

    run(`julia --project $jl`)

end
