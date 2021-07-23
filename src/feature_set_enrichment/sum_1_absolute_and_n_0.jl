function sum_1_absolute_n_0(
    ve::Vector{Float64},
    bo_::Vector{Float64},
)::Tuple{Float64,Float64}

    su1 = 0.0

    su0 = 0.0

    for ie = 1:length(ve)

        if bo_[ie] == 1.0

            nu = ve[ie]

            if nu < 0.0

                nu = abs(nu)

            end

            su1 += nu

        else

            su0 += 1.0

        end

    end

    return su1, su0

end

export sum_1_absolute_n_0
