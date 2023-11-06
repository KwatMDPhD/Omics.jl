module TimeXSample

function expand(ti_, ti_x_sa_x_nu)

    if !all(>(0), diff(ti_))

        error("Times are not increasing. $ti_.")

    end

    st_x_sa_x_nu = Matrix{Float64}(undef, 5, size(ti_x_sa_x_nu, 2))

    for (id, nu_) in enumerate(eachcol(ti_x_sa_x_nu))

        st_x_sa_x_nu[1, id] = maximum(nu_)

        st_x_sa_x_nu[2, id] = sum(nu_)

        st_x_sa_x_nu[3, id] = nu_[end] - nu_[1]

        de = ic = 0

        for di in diff(nu_)

            if di < 0

                de -= di

            elseif 0 < di

                ic += di

            end

        end

        st_x_sa_x_nu[4, id] = de

        st_x_sa_x_nu[5, id] = ic

    end

    vcat(ti_, ["Maximum", "Sum", "Change", "Decrease", "Increase"]),
    vcat(ti_x_sa_x_nu, st_x_sa_x_nu)

end

end
