using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

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

const MO_ = BioLab.Path.read(SR)

const TE_ = BioLab.Path.read(@__DIR__)

# ---- #

for jl in MO_

    @test chop(jl; tail = 3) == chop(readline(joinpath(SR, jl)); head = 7, tail = 0)

end

# ---- #

@test symdiff(MO_, TE_) == ["BioLab.jl", "runtests.jl"]

# ---- #

for jl in TE_

    if jl != "runtests.jl"

        @info "Testing $jl"

        run(`julia --project $jl`)

    end

end
