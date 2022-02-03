function clean(na::String; pr::Bool = false)::String

    na2 = replace(lowercase(na), r"[^_.0-9a-z]" => '_')

    if pr

        println(na, " ==> ", na2)

    end

    return na2

end
