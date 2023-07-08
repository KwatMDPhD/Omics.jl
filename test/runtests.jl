using Aqua

using Test

using BioLab

# ---- #

Aqua.test_all(BioLab; ambiguities = false)

Aqua.test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

const SR = joinpath(dirname(@__DIR__), "src")

const MO_ = filter!(!startswith('_'), readdir(SR))

# ---- #

for mo in MO_

    @test mo[1:(end - 3)] == split(readline(joinpath(SR, mo)))[2]

end

# ---- #

@test isconst(BioLab, :DA)

@test basename(BioLab.DA) == "data"

@test isdir(BioLab.DA)

# ---- #

@test isconst(BioLab, :TE)

@test basename(BioLab.TE) == "BioLab"

@test isdir(BioLab.TE)

@test isempty(readdir(BioLab.TE))

# ---- #

@test BioLab.@is_error error("@is_error passed its test.")

# ---- #

const TE_ = filter!(!startswith('_'), readdir(@__DIR__))

# ---- #

@test symdiff(MO_, TE_) == ["BioLab.jl", "runtests.jl"]

# ---- #

for te in TE_

    if te != "runtests.jl"

        @info "Testing $te"

        run(`julia --project $te`)

    end

end
