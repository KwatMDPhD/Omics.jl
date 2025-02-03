module XSample

function rea(ta, co, sa_)

    na_ = names(ta)

    ta[!, co], Matrix(ta[!, map(sa -> findall(contains(sa), na_)[], sa_)])

end

function align(fu, s1_, v1, s2_, v2)

    s3_ = map(fu, s1_)

    it_ = intersect(s3_, s2_)

    @warn "" setdiff(union(s3_, s2_), it_)

    i1_ = indexin(it_, s3_)

    s1_[i1_], v1[:, i1_], v2[:, indexin(it_, s2_)]

end

function joi(fi, f1_, s1_, v1, f2_, s2_, v2)

    f3_ = union(f1_, f2_)

    s3_ = union(s1_, s2_)

    v3 = fill(fi, lastindex(f3_), lastindex(s3_))

    f3_i3 = Dict(f3 => i3 for (i3, f3) in enumerate(f3_))

    s3_i3 = Dict(s3 => i3 for (i3, s3) in enumerate(s3_))

    for is in eachindex(s1_)

        i3 = s3_i3[s1_[is]]

        for ie in eachindex(f1_)

            v3[f3_i3[f1_[ie]], i3] = v1[ie, is]

        end

    end

    for is in eachindex(s2_)

        i3 = s3_i3[s2_[is]]

        for ie in eachindex(f2_)

            v3[f3_i3[f2_[ie]], i3] = v2[ie, is]

        end

    end

    f3_, s3_, v3

end

end
