using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

@test isconst(BioLab, :_DA)

@test basename(BioLab._DA) == "data"

@test readdir(BioLab._DA) ==
      ["CLS", "Dict", "FeatureSetEnrichment", "GCT", "GMT", "Gene", "Plot", "SingleCell", "Table"]

# ---- #

@test isconst(BioLab, :TE)

@test basename(BioLab.TE) == "BioLab"

@test isempty(readdir(BioLab.TE))

# ---- #

function read_filter(di)

    filter!(!startswith('_'), readdir(di))

end

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

const MO_ = read_filter(SR)

# ---- #

for jl in MO_

    @test chop(jl; tail = 3) == chop(readline(joinpath(SR, jl)); head = 7, tail = 0)

end

# ---- #

@test BioLab.@is_error error("This is an error message.")

# ---- #

const TE_ = read_filter(@__DIR__)

# ---- #

@test symdiff(MO_, TE_) == ["BioLab.jl", "runtests.jl"]

# ---- #

for jl in TE_

    if jl != "runtests.jl"

        @info "Testing $jl"

        run(`julia --project $jl`)

    end

end
