function apply!(ma, di, fu!)

    if di == 1

        ea = eachrow

    elseif di == 2

        ea = eachcol

    else

        error()

    end

    for ve in ea(ma)

        fu!(ve)

    end

    nothing

end
