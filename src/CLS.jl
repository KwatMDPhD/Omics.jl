module CLS

using DataFrames

function read(cl)

    li1, li2, li3 = readlines(cl)

    li1 = lstrip(li1, '#')

    li2 = lstrip(li2, '#')

    sp3_ = split(li3)

    if li1 == "numeric"

        DataFrame(
            "Target" => li2,
            ("Sample $id" => parse(Float64, nu) for (id, nu) in enumerate(sp3_))...,
        )

    else

        sp1_ = split(li1)

        n_sa1 = parse(Int, sp1_[1])

        n_sa3 = length(sp3_)

        if n_sa1 != n_sa3

            error("There are $n_sa3 samples, which is not $n_sa1 (line 1).")

        end

        n_gr1 = parse(Int, sp1_[2])

        na_ = split(li2)

        n_gr2 = length(na_)

        n_gr3 = length(unique(sp3_))

        if !(n_gr1 == n_gr2 == n_gr3)

            error("There are $n_gr3 groups, which is not $n_gr1 (line 1) or $n_gr2 (line 2).")

        end

        na_id = Dict(na => id for (id, na) in enumerate(na_))

        DataFrame(
            "Target" => join(na_, " vs "),
            ("Sample $id" => na_id[na] for (id, na) in enumerate(sp3_))...,
        )

    end

end

end
