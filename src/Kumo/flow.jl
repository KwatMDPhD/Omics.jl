function _increase(cu, fl_)

    maximum(vcat(cu, fl_))

end

function _decrease(cu, fl_)

    0.0

end

function flow(he_::AbstractVector, so_x_de_x_ed = edge(); n = 10^3, ch = 10^-6, pr = true)

    #
    no = _heat_check(he_, pr)

    #
    he__ = Vector{Float64}[he_]

    for id in 1:n

        #
        hec_ = copy(he__[end])

        for (id, (ed_, de)) in enumerate(zip(eachcol(so_x_de_x_ed), VE_))

            #
            if all(ed == 0 for ed in ed_)

                continue

            end

            #
            fl_ = hec_[convert(BitVector, ed_)]

            #
            if isconcretetype(de)

                hec_[id] = _increase(hec_[id], fl_)

                #
            elseif all(0.0 < fl for fl in fl_)

                ex = splitext(de)[2]

                if ex == ".de"

                    fu = _decrease

                elseif ex == ".in"

                    fu = _increase

                end

                hec_[id] = fu(hec_[id], fl_)

            end

        end

        #
        noc = _heat_check(hec_, pr)

        if abs(noc - no) < ch

            if pr

                println("$id 🏁")

            end

            break

        end

        #
        no = noc

        push!(he__, hec_)

    end

    #
    he__

end

function flow(ve_x_sa_x_he; ke_ar...)

    so_x_de_x_ed = edge()

    he___ = []

    for he_ in eachcol(ve_x_sa_x_he)

        push!(he___, flow(he_, so_x_de_x_ed; ke_ar...))

    end

    he___, hcat((he__[end] for he__ in he___)...)

end
