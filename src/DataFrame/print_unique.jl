function print_unique(ro_x_co_x_an; di = 2)

    _x_co_x_an = ro_x_co_x_an[!, 2:end]

    if di == 1

        na_ = ro_x_co_x_an[!, 1]

        an__ = eachrow(_x_co_x_an)

    elseif di == 2

        na_ = names(ro_x_co_x_an)[2:end]

        an__ = eachcol(_x_co_x_an)

    else

        error()

    end

    for (na, an_) in zip(na_, an__)

        println("🔦 $na")

        BioLab.Dict.print(sort(countmap(an_); byvalue = true); so = false)

    end

    return nothing

end
