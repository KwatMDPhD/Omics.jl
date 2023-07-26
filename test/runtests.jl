#using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

@test isconst(BioLab, :_DA)

@test basename(BioLab._DA) == "data"

@test readdir(BioLab._DA) == [
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

@test basename(BioLab.TE) == "BioLab"

@test isempty(readdir(BioLab.TE))

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

const IG_ = (r"^[!_]",)

const MO_ = BioLab.Path.read(SR; ig_ = IG_)

const TE_ = BioLab.Path.read(@__DIR__; ig_ = IG_)

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
