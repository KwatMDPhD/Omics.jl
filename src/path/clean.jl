function clean(na::String)::String

    na2 = replace(lowercase(na), r"[^\w.]" => '_')

    println("$na ==> $na2")

    return na2

end

export clean
