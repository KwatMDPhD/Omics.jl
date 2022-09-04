function print_unique(ro_)

    for ro in ro_

        na, an_ = ro[1], ro[2:end]

        un_ = sort(unique(an_))

        n_un = length(un_)

        de = "\n  "

        println("$na ($n_un):$de$(join(un_, de))")

    end

end
