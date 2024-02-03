module Clustering

using Clustering: cutree, hclust

using StatsBase: mean, mode

using ..Nucleus

function hierarchize(di)

    hclust(di; linkage = :ward)

end

function hierarchize(fu, nu___)

    hierarchize(Nucleus.Distance.pairwise(fu, nu___))

end

function order(fu, la_, nu___)

    i1_ = Int[]

    for la in sort!(unique(la_))

        id_ = findall(==(la), la_)

        append!(i1_, view(id_, hierarchize(fu, view(nu___, id_)).order))

    end

    i1_

end

function _title(ti, sc)

    Dict("text" => "$ti<br>$(Nucleus.Number.format4(sc))")

end

const XAXIS = Dict("dtick" => 1, "title" => Dict("text" => "Number of Group"))

# TODO: Plot.
function compare_grouping(fu, ht, it_, ma; ti = "")

    hi = hierarchize(fu, eachcol(ma))

    ng_ = eachindex(unique(it_))

    mu_ = [
        Nucleus.Information.get_mutual_information(
            Nucleus.Probability.get_joint(it_, cutree(hi; k = ng)),
            true,
        ) for ng in ng_
    ]

    sc = mean(mu_)

    Nucleus.Plot.plot_scatter(
        ht,
        (mu_,),
        (ng_,);
        layout = Dict(
            "title" => _title(ti, sc),
            "yaxis" => Dict("title" => Dict("text" => "Mutual Information")),
            "xaxis" => XAXIS,
        ),
    )

    sc

end

function compare_grouping(fu, ht, la_, ma, fr; ti = "")

    lu_ = unique(la_)

    ng_ = eachindex(lu_)

    nl = lastindex(lu_)

    nn = lastindex(ng_)

    tg = zeros(Int, nl, nn)

    hi = hierarchize(fu, eachcol(ma))

    la_gr_ = Dict(la => Int[] for la in lu_)

    for (i2, ng) in enumerate(ng_)

        for (la, gr) in zip(la_, cutree(hi; k = ng))

            push!(la_gr_[la], gr)

        end

        for (i1, la) in enumerate(lu_)

            gr_ = la_gr_[la]

            mo = mode(gr_)

            if fr <= count(==(mo), gr_) / lastindex(gr_)

                tg[i1, i2] = mo

            end

            empty!(gr_)

        end

    end

    no_ = count.(!iszero, eachrow(view(tg, :, 2:nn)))

    i1_ = sortperm(no_)

    sc = sum(no_) / (nl * (nn - 1))

    Nucleus.Plot.plot_heat_map(
        ht,
        view(tg, i1_, :);
        y = view(lu_, i1_),
        x = ng_,
        nr = "Label",
        nc = "Number of Group",
        co = Nucleus.Color._make_color_scheme(vcat("#000000", Nucleus.Color.COPO.colors)),
        layout = Dict("title" => _title(ti, sc), "yaxis" => Dict("dtick" => 1), "xaxis" => XAXIS),
    )

    sc

end

end
