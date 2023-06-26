include("environment.jl")

# ---- #

Aqua.test_all(BioLab; ambiguities = false)

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

@test isconst(BioLab, :DA)

@test basename(BioLab.DA) == "data"

@test isdir(BioLab.DA)

# ---- #

@test isconst(BioLab, :TE)

@test basename(BioLab.TE) == "BioLab"

@test isdir(BioLab.TE)

@test isempty(readdir(BioLab.TE))

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
