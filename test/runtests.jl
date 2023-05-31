using Test

using Aqua

using BioLab

# ---- #

# Aqua.test_all(BioLab; ambiguities = false)

# Aqua.test_ambiguities(BioLab)

# ----------------------------------------------------------------------------------------------- #

function is_jl(na)

    !startswith(na, '_') && endswith(na, ".jl")

end

@test symdiff(
    (na for na in readdir(joinpath(dirname(@__DIR__), "src")) if is_jl(na) && na != "BioLab.jl"),
    (na for na in readdir(@__DIR__) if is_jl(na) && na != "runtests.jl"),
) == ["environment.jl"]

# ---- #

BioLab.print_header("Testing BioLab.jl")

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

BioLab.print_header("I Got a Woman")

# ---- #

BioLab.print_header()

# ---- #

@test BioLab.@is_error error("Amen")

# ---- #

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "runtests.jl"

        BioLab.print_header("Testing $na")

        run(`julia --project $na`)

    end

end
