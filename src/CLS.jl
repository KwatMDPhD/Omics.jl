module CLS

using ..BioLab

function read(cl)

    li1, li2, li3 = readlines(cl)

    li2c = chop(li2; head = 1, tail = 0)

    sp3_ = split(li3)

    n_sa3 = length(sp3_)

    nar = "Target"

    co_ = ["Sample $id" for id in 1:n_sa3]

    id_ = 1:1

    if li1 == "#numeric"

        BioLab.DataFrame.make(nar, li2c, co_, [parse(Float64, nu) for _ in id_, nu in sp3_])

    else

        sp1_ = split(li1)

        n_sa1 = parse(Int, sp1_[1])

        if n_sa1 != n_sa3

            error("Numbers of samples differ. $n_sa1 (line 1) != $n_sa3 (line 3).")

        end

        n_gr1 = parse(Int, sp1_[2])

        gr_ = split(li2c)

        n_gr2 = length(gr_)

        n_gr3 = length(unique(sp3_))

        if !(n_gr1 == n_gr2 == n_gr3)

            error(
                "Numbers of groups differ. !($n_gr1 (line 1) == $n_gr2 (line 2) == $n_gr3 (line 3)).",
            )

        end

        gr_id = Dict(gr => id for (id, gr) in enumerate(gr_))

        BioLab.DataFrame.make(nar, join(gr_, '_'), co_, [gr_id[gr] for _ in id_, gr in sp3_])

    end

end

end
