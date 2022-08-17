function flow()

    ve_x_ve_x_ed = edge()

    global HEAT_

    ve_x_ve_x_fl = ve_x_ve_x_ed * Diagonal(HEAT_)

    up_ = []

    for (ed_, fl_) in zip(eachrow(ve_x_ve_x_ed), eachrow(ve_x_ve_x_fl))

        fle_ = fl_[convert(BitVector, ed_)]

        if sum(fle_) == 0.0

            ne = 0.0

        else

            ne = mean(fle_)

        end

        push!(up_, ne)

    end

    HEAT_ += up_

    HEAT_ /= 2

    _heat_check()

    ve_x_ve_x_fl

end
