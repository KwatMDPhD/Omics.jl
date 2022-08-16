function flow()

    ve_x_ve_x_ed = edge()

    global HEAT_

    ve_x_ve_x_fl = ve_x_ve_x_ed * Diagonal(HEAT_)

    up_ = []

    for (ed_, fl_) in zip(eachrow(ve_x_ve_x_ed), eachrow(ve_x_ve_x_fl))

        if sum(ed_) == 0

            ne = 0

        else

            ne = prod(fl_[convert(BitVector, ed_)])

        end

        push!(up_, ne)

    end

    HEAT_ += up_

    ve_x_ve_x_fl, up_

end
