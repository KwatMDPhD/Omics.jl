using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

@test isempty(BioLab.Path.read(BioLab.TE))

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

# ---- #

const MO_ = BioLab.Path.read(SR; ig_ = ("BioLab.jl",))

# ---- #

for jl in MO_

    @test jl[1:(end - 3)] === readline(joinpath(SR, jl))[8:end]

end

# ---- #

const TE_ = BioLab.Path.read(@__DIR__; ig_ = ("runtests.jl",))

# ---- #

@test isempty(symdiff(MO_, TE_))

# ---- #

for jl in TE_

    @info "Testing $jl"

    run(`julia --project $jl`)

end
