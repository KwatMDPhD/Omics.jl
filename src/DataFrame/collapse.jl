# TODO: Try with `groupby`
function collapse(da, fu = median)

    println("Before")

    println((size(da)))

    ro_id_ = Dict()

    na, ro_, co_, ma = OnePiece.DataFrame.separate(da)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, []), id)

    end

    ro2_ = []

    ma2 = Matrix(undef, length(ro_id_), length(co_))

    for (id2, (ro, id_)) in enumerate(sort(ro_id_))

        push!(ro2_, ro)

        if length(id_) == 1

            va_ = ma[id_[1], :]

        else

            va_ = [fu(co) for co in eachcol(ma[id_, :])]

        end

        ma2[id2, :] = va_

    end

    da2 = OnePiece.DataFrame.make(na, ro2_, co_, ma2)

    println("After")

    println((size(da2)))

    da2

end
