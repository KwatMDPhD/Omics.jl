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

    n_roc = length(ro_id_)

    roc_ = Vector{String}(undef, n_roc)

    roc_x_co_x_nu = Matrix{Float64}(undef, (n_roc, length(co_)))

    for (idc, (ro, id_)) in enumerate(ro_id_)

        roc_[idc] = ro

        if length(id_) == 1

            nu_ = ro_x_co_x_nu[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ro_x_co_x_nu[id_, :])]

        end

        roc_x_co_x_nu[idc, :] = nu_

    end

    roc_x_co_x_nu = BioLab.DataFrame.make(ro, roc_, co_, roc_x_co_x_nu)

    if pr

        println("📐 After $(size(roc_x_co_x_nu))")

    end

    roc_x_co_x_nu

end
