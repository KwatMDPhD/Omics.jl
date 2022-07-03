function _sum_1_absolute_and_0_count(sc_::Vector{Float64}, in_::Vector{Bool})

    su1 = 0.0

    su0 = 0.0

    @inbounds @fastmath @simd for id in 1:length(sc_)

        if in_[id]

            nu = sc_[id]

            if nu < 0.0

                nu = -nu

            end

            su1 += nu

        else

            su0 += 1.0

        end

    end

    su1, su0

end
