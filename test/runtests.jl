TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE; recursive = true)

end

mkdir(TE)

#using Revise
using BenchmarkTools

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

dis_ = Set(vcat([splitpath(su) for su in su_]...))

di_ = Set(vcat([wa[2] for wa in walkdir(pas)]...))

symdiff(dis_, di_)

using JSON
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

            cu = cu[di]

        else

            jl_ = [fi for fi in readdir(joinpath(pas, su)) if occursin(r"\.jl$", fi)]

            cu[di] = [joinpath(su, jl) for jl in jl_]

            cu = tr[mo]

        end

    end

end

JSON.print(tr, 2)

function write_line(io, st)

    return write(io, string(st, "\n"))

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

for su in su_

    nb = joinpath(pat, string(su, ".ipynb"))

    println("Running ", nb)

    run(
        `jupyter-nbconvert --execute --ExecutePreprocessor.timeout=-1 --clear-output --inplace --log-level 0 $nb`,
    )

end

rm(TE; recursive = true)
