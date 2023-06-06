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

BioLab.print_header("Testing BioLab.jl")

# ---- #

BioLab.print_header()

# ---- #

for pr in (true, false)

    BioLab.check_print(
        pr,
        1972,
        '.',
        0,
        4,
        '.',
        0,
        9,
        ' ',
        "Elvis Presley Performs at Hampton Roads Coliseum, VA",
    )

end

# ---- #

@test BioLab.@is_error error("Amen")

# ---- #

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "runtests.jl"

        BioLab.print_header("Testing $na")

        run(`julia --project $na`)

    end

end
