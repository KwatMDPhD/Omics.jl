function clean(st::String)::String

    st2 = replace(lowercase(st), r"[^\w.]" => '_')

    println("$st ==> $st2")

    return st2

end

export clean
