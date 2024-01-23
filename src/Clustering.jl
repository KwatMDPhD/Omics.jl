module Clustering

using Clustering: cutree, hclust

using StatsBase: mean, mode

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

const XAXIS = Dict("dtick" => 1, "title" => Dict("text" => "Number of Group"))

# TODO: Test.
function compare_grouping(ht, la_, ma; fu = Nucleus.Distance.Euclidean(), title_text = "")

    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(ma)))

    ng_ = eachindex(unique(la_))

    mu_ = [Nucleus.Information.get_mutual_information(la_, cluster(hi, ng)) for ng in ng_]

    me = mean(mu_)

    Nucleus.Plot.plot_scatter(
        ht,
        (mu_,),
        (ng_,);
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me))"),
            "yaxis" => Dict("title" => Dict("text" => "Mutual Information")),
            "xaxis" => XAXIS,
        ),
    )

    me

end

# TODO: Test.
function compare_grouping(ht, la_, ma, fr; fu = Nucleus.Distance.Euclidean(), title_text = "")

    lu_ = unique(la_)

    ng_ = eachindex(lu_)

    nl = lastindex(lu_)

    nn = lastindex(ng_)

    ti = zeros(Int, nl, nn)

    # TODO: Use information.
    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(ma)))

    la_gr_ = Dict(la => Int[] for la in lu_)

    for (i2, ng) in enumerate(ng_)

        for (la, gr) in zip(la_, cluster(hi, ng))

            push!(la_gr_[la], gr)

        end

        for (i1, la) in enumerate(lu_)

            gr_ = la_gr_[la]

            mo = mode(gr_)

            if fr <= count(==(mo), gr_) / lastindex(gr_)

                ti[i1, i2] = mo

            end

            empty!(gr_)

        end

    end

    no_ = count.(!iszero, eachrow(view(ti, :, 2:nn)))

    i1_ = sortperm(no_)

    me = sum(no_) / (nl * (nn - 1))

    Nucleus.Plot.plot_heat_map(
        ht,
        view(ti, i1_, :);
        y = view(lu_, i1_),
        x = ng_,
        nr = "Label",
        nc = "Number of Group",
        co = Nucleus.Color._make_color_scheme(vcat("#000000", Nucleus.Color.COPO.colors)),
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me * 100))%"),
            "yaxis" => Dict("dtick" => 1),
            "xaxis" => XAXIS,
        ),
    )

    me

end

end
