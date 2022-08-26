function _increase(cu, wa)

    (cu + wa) / 2.0

end

function flow!(he_; de_x_so_x_ed = edge(), n_fl = 1000, ch = 1e-6)

    no1 = 0.0

    for id in 1:n_fl

        for (id, (ve, so_)) in enumerate(zip(VERTEX_, eachrow(de_x_so_x_ed)))

            if all(so_ .== 0)

                continue

            end

            fl_ = he_[convert(BitVector, so_)]

            wa = mean(fl_)

            if ve isa DataType

                he_[id] = _increase(he_[id], wa)

            elseif all(0.0 .< fl_)

                ex = splitext(ve)[2]

                if ex == ".de"

                    he_[id] = 0.0

                elseif ex == ".in"

                    he_[id] = _increase(he_[id], wa)

                end

            end

        end

        no2 = _heat_check(he_)

        if abs(no2 - no1) < ch

            println("$id 🏁")

            break

        end

        no1 = no2

    end

    he_

end

function flow!(ve_x_sa_x_he::Matrix; ke_ar...)

    de_x_so_x_ed = edge()

    for he_ in eachcol(ve_x_sa_x_he)

        flow!(he_; de_x_so_x_ed = de_x_so_x_ed, ke_ar...)

    end

    ve_x_sa_x_he

end
