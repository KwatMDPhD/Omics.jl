function clean(pa)

    cl = replace(lowercase(pa), r"[^_.0-9a-z]" => '_')

    println("$pa 🧼 $cl")

    return cl

end
