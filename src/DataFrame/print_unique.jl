function print_unique(ro_x_co_x_an)

    de = "\n  "

    for an_ in eachrow(ro_x_co_x_an)

        ro, an_ = an_[1], an_[2:end]

        anu_ = sort(unique(an_))

        n = length(anu_)

        println("$ro ($n):$de$(join(anu_, de))")

    end

end
