function field()

    for na in names(Main)

        ev = Base.eval(Main, na)

        if ev isa DataType

            for ty in ev.types

                add(ev, ty)

            end

        end

    end

end
