function transplant(
    pa1,
    pa2,
    de,
    id_,
    re_,
)

    st1 = read(pa1, String)

    st2 = read(pa2, String)

    if length(id_) == 0

        st = st1

    else

        st = more_string_transplant(st1, st2, de, id_)

    end

    if st != st2

        println("Transplanting ", pa2)

        write(pa2, more_string_replace(st, re_))

    end

    return

end
