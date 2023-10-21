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

# Tuple!
const MO_ = BioLab.Path.read(SR; ig_ = ("BioLab.jl",))

# ---- #

for jl in MO_

    li = readline(joinpath(SR, jl))

    @test view(jl, 1:(lastindex(jl) - 3)) == view(li, 8:lastindex(li))

end

# ---- #

# Tuple!
const TE_ = BioLab.Path.read(@__DIR__; ig_ = ("runtests.jl",))

# ---- #

@test isempty(symdiff(MO_, TE_))

# ---- #

for jl in TE_

    @info "Testing $jl"

    run(`julia --project $jl`)

end
