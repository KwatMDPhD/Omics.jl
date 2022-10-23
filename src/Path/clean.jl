function clean(na)

    cl = replace(lowercase(na), r"[^_.0-9a-z]" => "_")

    println(na, " ==> ", cl)

    cl

end
