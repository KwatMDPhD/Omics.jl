function _increase(cu, wa)

    (cu + wa) / 2.0

end

function flow(he_; de_x_so_x_ed = edge(), n_fl = 1000, ch = 1e-6, pr = true)

    he__ = [he_]

    no1 = 0.0

    for id in 1:n_fl

        he2_ = copy(he__[end])

        for (id, (ve, so_)) in enumerate(zip(VERTEX_, eachrow(de_x_so_x_ed)))

            if all(so_ .== 0)

                continue

            end

            fl_ = he2_[convert(BitVector, so_)]

            wa = mean(fl_)

            if ve isa DataType

                he2_[id] = _increase(he2_[id], wa)

            elseif all(0.0 .< fl_)

                ex = splitext(ve)[2]

                if ex == ".de"

                    he2_[id] = 0.0

                elseif ex == ".in"

                    he2_[id] = _increase(he2_[id], wa)

                else

                    error()

                end

            end

        end

        no2 = _heat_check(he2_, pr = pr)

        if abs(no2 - no1) < ch

            if pr

                println("$id 🏁")

            end

            break

        end

        push!(he__, he2_)

        no1 = no2

    end

    he__

end

function flow(ve_x_sa_x_he::Matrix; ke_ar...)

    de_x_so_x_ed = edge()

    he___ = []

    for he_ in eachcol(ve_x_sa_x_he)

        push!(he___, flow(collect(he_); de_x_so_x_ed = de_x_so_x_ed, ke_ar...))

    end

    he___, hcat([he__[end] for he__ in he___]...)

end
