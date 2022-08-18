function flow()

    ve_x_ve_x_ed = edge()

    ex_ = [".act", ".react"]

    for (id, (ve, co_)) in enumerate(zip(VERTEX_, eachrow(ve_x_ve_x_ed)))

        fl_ = HEAT_[convert(BitVector, co_)]

        if !(isempty(fl_) || splitext(string(ve))[2] in ex_ && any(fl_ .== 0.0))

            println(mean(fl_))

            HEAT_[id] = mean([HEAT_[id], mean(fl_)])

        end

    end

    _heat_check()

end
