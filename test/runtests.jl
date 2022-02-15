TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

pam = dirname(@__DIR__)

pap = joinpath(pam, "Project.toml")

pas = joinpath(pam, "src")

pat = joinpath(pam, "test")

;

using TOML

to = TOML.parse(read(pap, String))

mo = "OnePiece"

@assert to["name"] == splitext(basename(pam))[1] == mo

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
    "feature_by_sample",
    "gene",
    "feature_set_enrichment",
]

;

symdiff(Set(vcat([splitpath(su) for su in su_]...)), Set(vcat([wa[2] for wa in walkdir(pas)]...)))

using OrderedCollections

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

            jl_ = [fi for fi in readdir(joinpath(pas, su)) if occursin(r"\.jl$", fi)]

            cu[di] = [joinpath(su, jl) for jl in jl_]

            global cu = tr[mo]

        end

    end

end

function write_line(io, st)

    write(io, string(st, "\n"))

end

function write_branch(io, id, va)

    sp = "  "^id

    if va isa OrderedDict

        for (ke, va2) in va

            write_line(io, string(sp, "module ", ke))

            write_branch(io, id + 1, va2)

            write_line(io, string(sp, "end"))

        end

    else

        for li in va

            write_line(io, string(sp, "include(\"", li, "\")"))

        end

    end


end

open(joinpath(pas, string(mo, ".jl")), "w") do io

    write_branch(io, 0, tr)

end

using OnePiece

de, id_ = "-"^3, [1, 2, 1]

for (id, su) in enumerate([su_..., "speed"])

    nb = joinpath(pat, string(su, ".ipynb"))

    println("Templating ", nb, " (", id, ")")

    run(`jupyter-nbconvert --clear-output --inplace --log-level 0 $nb`)

    OnePiece.templating.transplant("template.ipynb", nb, de, id_)

end

for (id, su) in enumerate(su_)

    nb = joinpath(pat, string(su, ".ipynb"))

    if id < 1

        continue

    end

    println(id)

    println("Running ", nb, " (", id, ")")

    run(
        `jupyter-nbconvert --execute --ExecutePreprocessor.timeout=-1 --clear-output --inplace --log-level 0 $nb`,
    )

end

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
