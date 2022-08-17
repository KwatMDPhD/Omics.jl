function load()

    for na in names(Main)

        ev = Base.eval(Main, na)

        if ev isa DataType

            _add(ev)

            for ty in ev.types

                _add(ty, ev)

            end

        end

    end

    n_ve = length(VERTEX_)

    n_ed = length(EDGE_)

    println(
        "Loaded $n_ve $(OnePiece.string.count_noun(n_ve,"vertex")) and $n_ed $(OnePiece.string.count_noun(n_ed, "edge")).",
    )

end
