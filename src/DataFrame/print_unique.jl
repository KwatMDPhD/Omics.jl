function print_unique(da)

    for va_ in eachrow(da)

        na, an_ = va_[1], va_[2:end]

        un_ = sort(unique(an_))

        n_un = length(un_)

        de = "\n  "

        println("$na ($n_un):$de$(join(un_, de))")

    end

end
