function load!()

    #
    for na in names(Main)

        ev = Base.eval(Main, na)

        if isconcretetype(ev)

            _add!(ev)

        end

    end

    #
    n_ve = length(VE_)

    n_ed = length(ED_)

    println(
        "Loaded $n_ve $(OnePiece.String.count_noun(n_ve, "vertex")) and $n_ed $(OnePiece.String.count_noun(n_ed, "edge")).",
    )

end
