function load!()

    for na in names(Main)

        ev = Base.eval(Main, na)

        if isconcretetype(ev)

            _add!(ev)

        end

    end

    n_ve = length(VERTEX_)

    n_ed = length(EDGE_)

    println(
        "Loaded $n_ve $(OnePiece.string.count_noun(n_ve, "vertex")) and $n_ed $(OnePiece.string.count_noun(n_ed, "edge")).",
    )

    VERTEX_, EDGE_

end
