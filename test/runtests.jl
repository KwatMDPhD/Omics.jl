TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

end

mkdir(TE)

#using Revise
using OnePiece

pa = dirname(@__DIR__)

pap = joinpath(pa, "Project.toml")

pas = joinpath(pa, "src")

pat = joinpath(pa, "test")

sr_ = [na for na in readdir(pas) if isdir(joinpath(pas, na))]

te_ = [splitext(na)[1] for na in readdir(pat) if endswith(na, ".ipynb")]

te_ = [te for te in te_ if !(te in ("runtests",))]

symdiff(sr_, te_)

for (id, te) in enumerate(te_)

    nb = joinpath(pat, "$te.ipynb")

    if id < 1

        continue

    end

    println("Running ", nb, " (", id, ")")

    run(
        `jupyter-nbconvert --log-level 40 --inplace --execute --ExecutePreprocessor.timeout=-1 --clear-output $nb`,
    )

end
