using Test

# ---- #

sr = joinpath(dirname(@__DIR__), "src")

function is_jl(na)

    endswith(na, ".jl")

end

@test symdiff(
    (na for na in readdir(sr) if is_jl(na) && na != "BioLab.jl"),
    (na for na in readdir(@__DIR__) if is_jl(na) && na != "runtests.jl"),
) == ["environment.jl"]

# ---- #

using BioLab

# ---- #

for pr in (true, false)

    BioLab.check_println(
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

BioLab.print_header()

# ---- #

BioLab.print_header("I Got a Woman")

# ---- #

@test BioLab.@is_error error("Amen")

# ---- #

include("Array.jl")

include("Constant.jl")
