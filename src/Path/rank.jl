function rank(di)

    na_ = readdir(di)

    for (id, na) in enumerate(sort!(na_; by = na -> parse(Float64, rsplit(na, '.'; limit = 3)[1])))

        na2 = "$id.$(join(rsplit(na, '.'; limit=3)[2:end], '.'))"

        if na != na2

            sr = joinpath(di, na)

            de = joinpath(di, na2)

            println("$sr ==> $de")

            mv(sr, de)

        end

    end

end
