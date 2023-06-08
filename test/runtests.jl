using Aqua

using Test

using BioLab

# ---- #

# Aqua.test_all(BioLab; ambiguities = false)

Aqua.test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

sr = joinpath(dirname(@__DIR__), "src")

mo_ = filter!(!startswith('_'), readdir(sr))

# ---- #

for mo in mo_

    @test splitext(mo)[1] == split(readline(joinpath(sr, mo)))[2]

end

# ---- #

@test isconst(BioLab, :TE)

@test basename(BioLab.TE) == "BioLab"

@test isdir(BioLab.TE)

@test isempty(readdir(BioLab.TE))

# ---- #

@test isconst(BioLab, :CA_)

@test BioLab.CA_ == ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

# ---- #

@test BioLab.@is_error error("Amen")

# ---- #

te_ = filter!(!startswith('_'), readdir(@__DIR__))

# ---- #

@test symdiff(mo_, te_) == ["BioLab.jl", "environment.jl", "runtests.jl"]

# ---- #

for te in te_

    if te != "runtests.jl"

        @info "Testing $te"

        run(`julia --project $te`)

    end

end
