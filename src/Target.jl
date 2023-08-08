module Target

function make_any_x_index_x_bit(an_)

    anu_ = sort(unique(an_))

    an_id = Dict(an => id for (id, an) in enumerate(anu_))

    an_x_id_x_bi = BitMatrix(undef, length(anu_), length(an_))

    for (id, an) in enumerate(an_)

        an_x_id_x_bi[an_id[an], id] = true

    end

    anu_, an_x_id_x_bi

end

function make_any1_x_label_x_any2(an1_, la_, fi, an2_)

    an1u_ = sort!(unique(an1_))

    lau_ = sort!(unique(la_))

    an1_x_la_x_an2 = fill(fi, length(an1u_), length(lau_))

    an1_id = Dict(an => id for (id, an) in enumerate(an1u_))

    for (idl, la) in enumerate(lau_)

        for id in findall(==(la), la_)

            an1_x_la_x_an2[an1_id[an1_[id]], idl] = an2_[id]

        end

    end

    an1u_, lau_, an1_x_la_x_an2

end

end
