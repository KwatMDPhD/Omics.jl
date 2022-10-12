function collapse(da, fu = median)

    println("Before")

    println((size(da)))

    ge_id_ = Dict()

    nar, ro_, co_, ma = OnePiece.data_frame.separate(da)

    for (id, ge) in enumerate(ro_)

        push!(get!(ge_id_, ge, []), id)

    end

    ro2_ = []

    ma2 = Matrix(undef, length(ge_id_), length(co_))

    for (id2, (ge, id_)) in enumerate(sort(ge_id_))

        push!(ro2_, ge)

        if length(id_) == 1

            ma2[id2, :] = ma[id_[1], :]

        else

            ma2[id2, :] = [fu(co) for co in eachcol(ma[id_, :])]

        end

    end

    da2 = OnePiece.data_frame.make(nar, ro2_, co_, ma2)

    println("After")

    println((size(da2)))

    da2

end
