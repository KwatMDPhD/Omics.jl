module CLS

using ..BioLab

function _make_matrix(fu, st_)

    [fu(st) for _ in 1:1, st in st_]

end

function read(cl)

    li1, li2, li3 = readlines(cl)

    li22 = view(li2, 2:lastindex(li2))

    li3_ = split(li3)

    n_sa3 = lastindex(li3_)

    nar = "Target"

    co_ = (id -> "Sample $id").(1:n_sa3)

    if li1 == "#numeric"

        BioLab.DataFrame.make(nar, li22, co_, _make_matrix(st -> parse(Float64, st), li3_))

    else

        li1_ = split(li1)

        n_sa1 = parse(Int, li1_[1])

        if n_sa1 != n_sa3

            error("Numbers of samples differ. $n_sa1 (line 1) != $n_sa3 (line 3).")

        end

        n_gr1 = parse(Int, li1_[2])

        gr_ = split(li22)

        n_gr2 = lastindex(gr_)

        n_gr3 = lastindex(unique(li3_))

        if !(n_gr1 == n_gr2 == n_gr3)

            error(
                "Numbers of groups differ. !($n_gr1 (line 1) == $n_gr2 (line 2) == $n_gr3 (line 3)).",
            )

        end

        gr_id = Dict(gr => id for (id, gr) in enumerate(gr_))

        BioLab.DataFrame.make(nar, join(gr_, '_'), co_, _make_matrix(st -> gr_id[st], li3_))

    end

end

end
