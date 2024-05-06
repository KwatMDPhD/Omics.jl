using Test: @test

using Nucleus

# ----------------------------------------------------------------------------------------------- #

@test isempty(readdir(Nucleus.TE))

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

# ---- #

const MO_ = Nucleus.Path.read(SR, r"^((?!Nucleus.jl).)*$")

# ---- #

for jl in MO_

    @test jl[1:(end - 3)] == readline(joinpath(SR, jl))[8:end]

end

# ---- #

const TE_ = Nucleus.Path.read(@__DIR__, r"^((?!runtests.jl).)*$")

# ---- #

@test isempty(symdiff(MO_, TE_))

# ---- #

for jl in TE_

    @info "Testing $jl"

    run(`julia --project $jl`)

end
