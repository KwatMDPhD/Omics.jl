using Test

# --------------------------------------------- #

te = @__DIR__

sr = joinpath(dirname(te), "src")

function is_jl(na)

    return endswith(na, r"\.jl$")

end

display(
    symdiff(
        (na for na in readdir(sr) if is_jl(na) && na != "BioLab.jl"),
        (na for na in readdir(te) if is_jl(na) && na != "runtests.jl"),
    ),
)

# --------------------------------------------- #

using BioLab

# --------------------------------------------- #

@test BioLab.RA == 20121020

# --------------------------------------------- #

@test BioLab.CA_ == ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

# --------------------------------------------- #

@test basename(BioLab.TE) == "BioLab" && isdir(BioLab.TE) && isempty(readdir(BioLab.TE))

# --------------------------------------------- #

# TODO: `@test`.

for pr in (true, false)

    BioLab.check_print(pr, "Aa", 2)

end

# @code_warntype BioLab.check_print(true, "Aa", 2)

# --------------------------------------------- #

# TODO: `@test`.

BioLab.print_header()

st = "Hello World!"

BioLab.print_header(st)

# @code_warntype BioLab.print_header(st)

# --------------------------------------------- #

@test BioLab.@is_error error()

# --------------------------------------------- #

BioLab.JL.run(@__DIR__, (r"^runtests\.jl$",))
