function transplant(pa1, pa2, de, id_, re_)

    st1 = read(pa1, String)

    st2 = read(pa2, String)

    if isempty(id_)

        st = st1

    else

        st = string_transplant(st1, st2, de, id_)

    end

    println("Transplanting ", pa2)

    write(pa2, string_replace(st, re_))

end
