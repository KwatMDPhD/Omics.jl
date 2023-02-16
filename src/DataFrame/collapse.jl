function collapse(ro_x_co_x_nu; fu = mean, pr = true)

    if pr

        println("📐 Before $(size(ro_x_co_x_nu))")

    end

    ro_id_ = OrderedDict{String, Vector{Int}}()

    ro, ro_::Vector{String}, co_, ro_x_co_x_nu::Matrix{Float64} =
        BioLab.DataFrame.separate(ro_x_co_x_nu)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Int[]), id)

    end

    n = length(ro_id_)

    ro2_ = Vector{String}(undef, n)

    ro2_x_co_x_nu = Matrix{Float64}(undef, (n, length(co_)))

    for (id2, (ro, id_)) in enumerate(ro_id_)

        ro2_[id2] = ro

        if length(id_) == 1

            nu_ = ro_x_co_x_nu[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ro_x_co_x_nu[id_, :])]

        end

        ro2_x_co_x_nu[id2, :] = nu_

    end

    ro2_x_co_x_nu = BioLab.DataFrame.make(ro, ro2_, co_, ro2_x_co_x_nu)

    if pr

        println("📐 After $(size(ro2_x_co_x_nu))")

    end

    return ro2_x_co_x_nu

end
