# TODO: `groupby`
function collapse(ro_x_co_x_nu, fu = median; pr = true)

    if pr

        println("Before")

        println(size(ro_x_co_x_nu))

    end

    ro_id_ = Dict{String, Vector{Int}}()

    ro, ro_, co_, ro_x_co_x_nu = BioLab.DataFrame.separate(ro_x_co_x_nu)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, []), id)

    end

    roc_ = []

    roc_x_co_x_nu = Matrix{Float64}(undef, (length(ro_id_), length(co_)))

    for (id2, (ro, id_)) in enumerate(sort(ro_id_))

        push!(roc_, ro)

        if length(id_) == 1

            nu_ = ro_x_co_x_nu[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ro_x_co_x_nu[id_, :])]

        end

        roc_x_co_x_nu[id2, :] = nu_

    end

    roc_x_co_x_nu = BioLab.DataFrame.make(ro, roc_, co_, roc_x_co_x_nu)

    if pr

        println("After")

        println(size(roc_x_co_x_nu))

    end

    roc_x_co_x_nu

end
