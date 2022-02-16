# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "templating.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
di = dirname(@__DIR__)

dit = joinpath(homedir(), "craft", "PkgRepository.jl", "TEMPLATE.jl")

try

    OnePiece.templating.error_missing(dit, di)

catch er

    er

end

OnePiece.templating.error_missing(dit, di; re_ = ["TEMPLATE.jl" => "OnePiece.jl"])

dit = joinpath(homedir(), "craft", "PkgRepository.jl")

try

    OnePiece.templating.error_missing(dit, di)

catch er

    er

end

OnePiece.templating.error_missing(
    dit,
    di;
    ig_ = [r"\.ipynb_checkpoints", r"\.git", r"src", r"TEMPLATE.jl", r"Comonicon.toml", r"deps"],
)

OnePiece.templating.plan_transplant()

OnePiece.templating.plan_replacement("Big Mom")

te = tempdir()

fit = joinpath(te, "fit")

write(
    fit,
    "# TEMPLATE
--
GIT_USER_NAME
GIT_USER_EMAIL
033e1703-1880-4940-9ddc-745bff01a2ac
--
(stuff)
--
ODA IS GENIUS.",
)

println(read(fit, String))

fi = joinpath(te, "fi")

write(
    fi,
    "(bad part)
--
(bad part)
--
GOOD STUFF
--
(bad part)",
)

println(read(fi, String))

OnePiece.templating.transplant(
    fit,
    fi,
    "--",
    [1, 1, 2, 1],
    re_ = OnePiece.templating.plan_replacement("Katakuri"),
)

println(read(fi, String))

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
