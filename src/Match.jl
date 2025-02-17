module Match

using Random: shuffle!

using StatsBase: sample

using ..Omics

function ge(fu, n1_, N; u1 = 10, u2 = 10)

    u3, u4 = size(N)

    R = Matrix{Float64}(undef, u3, 4)

    R[:, 1] = re_ = map(n2_ -> fu(n1_, n2_), eachrow(N))

    if iszero(u1)

        R[:, 2] .= NaN

    else

        ra_ = Vector{Float64}(undef, u1)

        u5 = round(Int, u4 * 0.632)

        for i1 in 1:u3

            n2_ = N[i1, :]

            for i2 in 1:u1

                # TODO: Sample from each group.
                i3_ = sample(1:u4, u5; replace = false)

                ra_[i2] = fu(n1_[i3_], n2_[i3_])

            end

            R[i1, 2] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if iszero(u2)

        R[:, 3:4] .= NaN

    else

        ra_ = Vector{Float64}(undef, u3 * u2)

        i3 = 0

        co_ = copy(n1_)

        for i1 in 1:u3

            n2_ = N[i1, :]

            for i2 in 1:u2

                ra_[i3 += 1] = fu(shuffle!(co_), n2_)

            end

        end

        i1_ = findall(<(0), re_)

        i2_ = findall(>=(0), re_)

        p1_, q1_, p2_, q2_ =
            Omics.Significance.ge(Omics.Numbe.separate(ra_)..., re_[i1_], re_[i2_])

        i3_ = vcat(i1_, i2_)

        R[i3_, 3] = vcat(p1_, p2_)

        R[i3_, 4] = vcat(q1_, q2_)

    end

    R

end

end
