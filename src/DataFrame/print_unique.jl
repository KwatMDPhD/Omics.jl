function print_unique(ro_x_co_x_an; di = 2)

    if di == 1

        ea = eachrow

    elseif di == 2

        ea = eachcol

    else

        error()

    end

    for an_ in ea(ro_x_co_x_an)

        println("🔦 $(an_[1])")

        BioLab.Dict.print(sort(countmap(an_[2:end]); byvalue = true); so = false)

    end

end
