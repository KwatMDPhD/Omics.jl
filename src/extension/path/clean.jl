function clean(na; pr = true)

    cl = replace(lowercase(na), r"[^_.0-9a-z]" => "_")

    if pr

        println(na, " ==> ", cl)

    end

    return cl

end
