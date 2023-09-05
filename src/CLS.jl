module CLS

using ..BioLab

function read(cl)

    li1, li2, li3 = readlines(cl)

    li2c = chop(li2; head = 1, tail = 0)

    sp3_ = split(li3)

    n_sa3 = length(sp3_)

    nar = "Target"

    co_ = string.("Sample ", 1:n_sa3)

    if li1 == "#numeric"

        BioLab.DataFrame.make(nar, li2c, co_, [parse(Float64, nu) for _ in 1:1, nu in sp3_])

    else

        sp1_ = split(li1)

        n_sa1 = parse(Int, sp1_[1])

        if n_sa1 != n_sa3

            error("There are ", n_sa3, " samples, not matching ", n_sa1, " (from line 1).")

        end

        n_gr1 = parse(Int, sp1_[2])

        gr_ = split(li2c)

        n_gr2 = length(gr_)

        n_gr3 = length(unique(sp3_))

        if !(n_gr1 == n_gr2 == n_gr3)

            error(
                "There are ",
                n_gr3,
                " groups, not matching ",
                n_gr1,
                " (from line 1) or ",
                n_gr2,
                " (from line 2).",
            )

        end

        gr_id = Dict(gr => id for (id, gr) in enumerate(gr_))

        BioLab.DataFrame.make(nar, join(gr_, '_'), co_, [gr_id[gr] for _ in 1:1, gr in sp3_])

    end

end

end
