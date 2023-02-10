# TODO: Use mapcount.
function print_unique(ro_x_co_x_an; di = 2)

    if di == 1

        ea = eachrow

    elseif di == 2

        ea = eachcol

    end

    de = "\n  "

    for an_ in ea(ro_x_co_x_an)

        na = an_[1]

        an_ = an_[2:end]

        un_ = unique(an_)

        try

            un_ = sort(un_)

        catch

        end

        println("🔦 $na ($(length(un_))):$de$(join(un_, de))")

    end

end
