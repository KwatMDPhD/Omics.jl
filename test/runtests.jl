using Aqua

using Test

using BioLab

# ---- #

# Aqua.test_all(BioLab; ambiguities = false)

Aqua.test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

sr = joinpath(dirname(@__DIR__), "src")

# ---- #

function is_jl(na)

    !startswith(na, '_') && endswith(na, ".jl")

end

@test symdiff(
    (na for na in readdir(sr) if is_jl(na) && na != "BioLab.jl"),
    (na for na in readdir(@__DIR__) if is_jl(na) && na != "runtests.jl"),
) == ["environment.jl"]

# ---- #

for na in readdir(sr)

    if !startswith(na, '_')

        @test splitext(na)[1] == split(readline(joinpath(sr, na)))[2]

    end

end

# ---- #

@test isconst(BioLab, :CA_)

@test BioLab.CA_ == ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

# ---- #

@test isconst(BioLab, :TE)

@test basename(BioLab.TE) == "BioLab"

@test isdir(BioLab.TE)

@test isempty(readdir(BioLab.TE))

# ---- #

@test BioLab.@is_error error("Amen")

# ---- #

@test BioLab.@is_error error("I Got a Woman") false

# ---- #

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "runtests.jl"

        run(`julia --project $na`)

    end

end
