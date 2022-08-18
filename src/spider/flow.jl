function flow(n_fl = 1000)

    ve_x_ve_x_ed = edge()

    ex_ = [".act", ".react"]

    no1 = 0.0

    for id in 1:n_fl

        for (id, (ve, co_)) in enumerate(zip(VERTEX_, eachrow(ve_x_ve_x_ed)))

            fl_ = HEAT_[convert(BitVector, co_)]

            if !(isempty(fl_) || splitext(string(ve))[2] in ex_ && any(fl_ .== 0.0))

                HEAT_[id] = mean([HEAT_[id], mean(fl_)])

            end

        end

        no2 = _heat_check()

        if abs(no2 - no1) < 1e-6

            println("$id 🏁")

            break

        end

        no1 = no2

    end

    plot()

end
