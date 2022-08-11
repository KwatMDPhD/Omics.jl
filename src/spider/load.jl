function load()

    for na in names(Main)

        ev = Base.eval(Main, na)

        if ev isa DataType

            add(ev)

            for ty in ev.types

                add(ev, ty)

            end

        end

    end

    n_ve = length(VE_)

    n_ed = length(ED_)

    ve = "vertex"

    if 1 < n_ve

        ve = replace(ve, r"ex$" => "ices")

    end

    ed = "edge"

    if 1 < n_ed

        ed *= "s"

    end

    println("Loaded $n_ve $ve and $n_ed $ed.")

end
