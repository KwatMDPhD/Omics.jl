function transplant(
    pa1::String,
    pa2::String,
    de::String,
    id_::Vector{Int64},
    re_::Vector{Pair{String,String}},
)::Nothing

    st1 = read(pa1, String)

    st2 = read(pa2, String)

    if length(id_) == 0

        st = st1

    else

        st = StringExtension.transplant(st1, st2, de, id_)

    end

    if st != st2

        println("Transplanting ", pa2)

        write(pa2, StringExtension.replace(st, re_))

    end

    return nothing

end
