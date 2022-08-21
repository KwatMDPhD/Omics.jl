function _increase(cu, wa)

    (cu + wa) / 2.0

end

function flow!(de_x_so_x_ed, he_; n_fl = 1000, ch = 1e-6)

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

                if ex == ".-"

                    he_[id] = 0.0

                elseif ex == ".+"

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

function flow!(_he_; ke_ar...)

    de_x_so_x_ed = make_edge_matrix()

    for he_ in _he_

        flow!(de_x_so_x_ed, he_; ke_ar...)

    end

    _he_

end
