function run(nb)

    Base.run(
        `jupyter-nbconvert --log-level 40 --inplace --execute --ExecutePreprocessor.timeout=-1 --clear-output $nb`,
    )

end

function run(di, sk_)

    nb_ = [na for na in readdir(di) if occursin(r".ipynb$", na) && !(na in sk_)]

    if all(occursin.(r"^[0-9]+\.", nb_))

        sort!(nb_, by = nb -> parse(Int64, split(nb, '.')[1]))

    end

    for (id, nb) in enumerate(nb_)

        nb = joinpath(di, nb)

        println("Running $nb ($id)")

        run(nb)

    end

end
