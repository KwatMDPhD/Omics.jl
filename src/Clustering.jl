module Clustering

using Clustering: cutree, hclust

using Distances: pairwise

using StatsBase: mode

using ..Nucleus

function hierarchize(di; linkage = :ward)

    hclust(di; linkage)

end

function hierarchize(fu, nu___; ke_ar...)

    hierarchize(pairwise(fu, nu___); ke_ar...)

end

function order(fu, la_, nu___)

    i1_ = Int[]

    for la in sort!(unique(la_))

        id_ = findall(==(la), la_)

        append!(i1_, view(id_, hierarchize(fu, view(nu___, id_)).order))

    end

    i1_

end

function _title(text, sc)

    Dict("text" => "$text<br>$(Nucleus.Number.format4(sc))")

end

const XAXIS = Dict("dtick" => 1, "title" => Dict("text" => "Number of Group"))

function compare_grouping(hi, ht, it_; text = "")

    ng_ = eachindex(unique(it_))

    mu_ = [
        Nucleus.Information.get_mutual_information(
            Nucleus.Probability.get_joint(it_, cutree(hi; k = ng)),
            true,
        ) for ng in ng_
    ]

    sc, id = findmax(mu_)

    Nucleus.Plot.plot_scatter(
        ht,
        (mu_, (sc,), (mu_[end],)),
        (ng_, (ng_[id],), (ng_[end],));
        name_ = ("All", "Maximum", "Last"),
        marker_ = (
            Dict("color" => Nucleus.Color.HEGR),
            Dict("size" => 24, "color" => Nucleus.Color.HERE),
            Dict("size" => 16, "color" => Nucleus.Color.HEBL),
        ),
        layout = Dict(
            "title" => _title(text, sc),
            "yaxis" => Dict(
                "range" => (0, 1),
                "title" => Dict("text" => "Mutual Information (Normalized)"),
            ),
            "xaxis" => merge(XAXIS, Dict("range" => (1, lastindex(ng_)))),
        ),
    )

    sc

end

function compare_grouping(hi, ht, la_, fr; text = "")

    lu_ = unique(la_)

    ng_ = eachindex(lu_)

    nl = lastindex(lu_)

    nn = lastindex(ng_)

    tg = zeros(Int, nl, nn)

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
        co = Nucleus.Color._make_color_scheme(vcat(Nucleus.Color.HEFA, Nucleus.Color.COPO.colors)),
        layout = Dict(
            "title" => _title(text, sc),
            "yaxis" => Dict("dtick" => 1, "title" => Dict("text" => "Label ($nl)")),
            "xaxis" => merge(XAXIS, Dict("title" => Dict("text" => "Number of Group ($nn)"))),
        ),
    )

    sc

end

end
