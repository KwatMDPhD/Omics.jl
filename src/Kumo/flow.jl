function _increase(cu, fl_)

    maximum(vcat(cu, fl_))

end

function _decrease(cu, fl_)

    0.0

end

function flow(he_, de_x_so_x_ed = edge(); n = 1000, ch = 1e-6, pr = true)

    no1 = _heat_check(he_, pr)

    he__ = [he_]

    for id in 1:n

        he2_ = copy(he__[end])

        for (id, (de, so_)) in enumerate(zip(VE_, eachrow(de_x_so_x_ed)))

            if all(so == 0 for so in so_)

                continue

            end

            fl_ = he2_[convert(BitVector, so_)]

            if isconcretetype(de)

                he2_[id] = _increase(he2_[id], fl_)

            elseif all(0.0 < fl for fl in fl_)

                ex = splitext(de)[2]

                if ex == ".de"

                    fu = _decrease

                elseif ex == ".in"

                    fu = _increase

                end

                he2_[id] = fu(he2_[id], fl_)

            end

        end

        no2 = _heat_check(he2_, pr)

        if abs(no2 - no1) < ch

            if pr

                println("$id 🏁")

            end

            break

        end

        no1 = no2

        push!(he__, he2_)

    end

    he__

end

function flow(ve_x_sa_x_he; ke_ar...)

    de_x_so_x_ed = edge()

    he___ = []

    for he_ in eachcol(ve_x_sa_x_he)

        push!(he___, flow(collect(he_), de_x_so_x_ed; ke_ar...))

    end

    he___, hcat([he__[end] for he__ in he___]...)

end
