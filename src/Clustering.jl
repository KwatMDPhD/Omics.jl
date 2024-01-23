module Clustering

using Clustering: cutree, hclust

using StatsBase: mode

using ..Nucleus

function hierarchize(an_x_an_x_di, linkage = :ward)

    hclust(an_x_an_x_di; linkage)

end

function cluster(hc, k)

    cutree(hc; k)

end

function order(fu, co_, ma, linkage = :ward)

    id_ = Int[]

    for co in sort!(unique(co_))

        idc_ = findall(==(co), co_)

        append!(
            id_,
            view(
                idc_,
                hierarchize(Nucleus.Distance.get(fu, eachcol(view(ma, :, idc_))), linkage).order,
            ),
        )

    end

    id_

end

function _mean(nu)

    sum(nu) / lastindex(nu)

end

# TODO: Test.
function compare_grouping(
    ht,
    id_::AbstractVector{<:Integer},
    ma,
    ng_ = eachindex(unique(id_));
    fu = Nucleus.Distance.Euclidean(),
    title_text = "",
)

    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(ma)))

    mu_ = [Nucleus.Information.get_mutual_information(id_, cluster(hi, ng)) for ng in ng_]

    me = _mean(mu_)

    Nucleus.Plot.plot_scatter(
        ht,
        (mu_,),
        (ng_,);
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me))"),
            "yaxis" => Dict("title" => Dict("text" => "Mutual Information")),
            "xaxis" => Dict("dtick" => 1, "title" => Dict("text" => "Number of Group")),
        ),
    )

    me

end

# TODO: Test.
function compare_grouping(
    ht,
    la_,
    ma,
    ng_ = eachindex(unique(la_));
    fu = Nucleus.Distance.Euclidean(),
    fr = 1.0,
    title_text = "",
)

    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(ma)))

    un_ = unique(la_)

    ti = Matrix{Int}(undef, lastindex(un_), lastindex(ng_))

    la_gr_ = Dict(la => Int[] for la in un_)

    for (i2, ng) in enumerate(ng_)

        for (la, gr) in zip(la_, cluster(hi, ng))

            push!(la_gr_[la], gr)

        end

        for (i1, la) in enumerate(un_)

            gr_ = la_gr_[la]

            ti[i1, i2] = fr <= count(==(mode(gr_)), gr_) / lastindex(gr_)

            empty!(gr_)

        end

    end

    me = _mean(ti)

    i1_ = sortperm(sum.(eachrow(ti)))

    Nucleus.Plot.plot_heat_map(
        ht,
        ti[i1_, :];
        y = un_[i1_],
        x = ng_,
        nr = "Label",
        nc = "Number of Group",
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me * 100))%"),
            "yaxis" => Dict("dtick" => 1),
            "xaxis" => Dict("dtick" => 1),
        ),
    )

    me

end

end
