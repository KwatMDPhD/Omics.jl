TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
pam = dirname(@__DIR__)

pap = joinpath(pam, "Project.toml")

pas = joinpath(pam, "src")

pat = joinpath(pam, "test")

# ----------------------------------------------------------------------------------------------- #
using TOML

# ----------------------------------------------------------------------------------------------- #
to = TOML.parse(read(pap, String))

mo = "OnePiece"

@assert splitext(basename(pam))[1] == to["name"] == mo

# ----------------------------------------------------------------------------------------------- #
su_ = [
    "io/table",
    "io/fcs",
    "io/gct",
    "io/gmt",
    #"io/pandas",
    "extension/constant",
    "extension/dict",
    "extension/vector",
    "extension/string",
    "extension/path",
    "extension/dataframe",
    "templating",
    "informatics/tensor",
    "informatics/geometry",
    "informatics/normalization",
    "informatics/statistics",
    "informatics/significance",
    "informatics/information",
    "emoji",
    "figure",
    "tensor_function",
    "feature_x_sample",
    "gene",
    "feature_set_enrichment",
]

n_sk = length(pas)

symdiff(Set(vcat([splitpath(su) for su in su_]...)), Set([wa[1][n_sk:end] for wa in walkdir(pas)]))

# ----------------------------------------------------------------------------------------------- #
using OrderedCollections

# ----------------------------------------------------------------------------------------------- #
tr = OrderedDict()

tr[mo] = OrderedDict()

cu = tr[mo]

for su in su_

    di_ = splitpath(su)

    n_di = length(di_)

    for (id, di) in enumerate(di_)

        if id < n_di

            if !haskey(cu, di)

                cu[di] = OrderedDict()

            end

            global cu = cu[di]

        else

            cu[di] = [
                fi for fi in readdir(joinpath(pas, su)) if occursin(r"\.jl$", fi) && fi != "$di.jl"
            ]

            global cu = tr[mo]

        end

    end

end

# ----------------------------------------------------------------------------------------------- #
using JSON

# ----------------------------------------------------------------------------------------------- #
JSON.print(tr, 2)

# ----------------------------------------------------------------------------------------------- #
function write_line(io, st)

    write(io, "$st\n\n")

end

# ----------------------------------------------------------------------------------------------- #
function write_branch(jl, io, va)

    if va isa OrderedDict

        for (su, va2) in va

            re = joinpath(su, "$su.jl")

            write_line(io, "include(\"$re\")")

            jl2 = joinpath(dirname(jl), re)

            open(jl2, "w") do io2

                write_line(io2, "module $su")

                write_branch(jl2, io2, va2)

                write_line(io2, "end")

            end

        end

    else

        for li in va

            write_line(io, "include(\"$li\")")

        end

    end

end

# ----------------------------------------------------------------------------------------------- #
jl = joinpath(pas, "$mo.jl")

open(jl, "w") do io

    write_line(io, "module $mo")

    write_branch(jl, io, tr[mo])

    write_line(io, "end")

end

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
de, id_ = "-"^3, [1, 2, 1]

for (id, su) in enumerate([su_..., "speed"])

    nb = joinpath(pat, "$su.ipynb")

    println("Templating $nb ($id)")

    run(`jupyter-nbconvert --clear-output --inplace --log-level 0 $nb`)

    OnePiece.templating.transplant(joinpath(@__DIR__, "template.ipynb"), nb, de, id_)

end

for (id, su) in enumerate(su_)

    nb = joinpath(pat, "$su.ipynb")

    if id < 1

        continue

    end

    println("Running $nb ($id)")

    run(
        `jupyter-nbconvert --execute --ExecutePreprocessor.timeout=-1 --clear-output --inplace --log-level 0 $nb`,
    )

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
