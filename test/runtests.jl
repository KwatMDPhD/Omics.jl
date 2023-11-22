using Test: @test

using Nucleus

# ----------------------------------------------------------------------------------------------- #

@test isempty(readdir(Nucleus.TE))

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

# ---- #

const MO_ = Nucleus.Path.read(SR; ig_ = ("Nucleus.jl",))

# ---- #

for jl in MO_

    li = readline(joinpath(SR, jl))

    @test view(jl, 1:(lastindex(jl) - 3)) == view(li, 8:lastindex(li))

end

# ---- #

const TE_ = Nucleus.Path.read(@__DIR__; ig_ = ("runtests.jl",))

# ---- #

@test symdiff(MO_, TE_) == ["Pathhere.jl"]

# ---- #

for jl in TE_

    @info "Testing $jl"

    run(`julia --project $jl`)

end
