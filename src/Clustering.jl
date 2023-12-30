module Clustering

using Clustering: cutree, hclust

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
    fe_x_sa_x_nu,
    ng_ = eachindex(unique(id_));
    fu = Nucleus.Distance.Euclidean(),
    title_text = "",
)

    n_gr = lastindex(ng_)

    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(fe_x_sa_x_nu)))

    # TODO: Normalize mutual information?
    mu_ = [Nucleus.Information.get_mutual_information(id_, cluster(hi, n_gr)) for n_gr in ng_]

    me = _mean(mu_)

    Nucleus.Plot.plot_scatter(
        ht,
        (mu_,),
        (ng_,);
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me))"),
            "yaxis" => Dict("title" => Dict("text" => "Mutual Information")),
            "xaxis" => Dict("title" => Dict("text" => "Number of Group")),
        ),
    )

    me

end

# TODO: Test.
function compare_grouping(
    ht,
    la_,
    fe_x_sa_x_nu,
    ng_ = eachindex(unique(la_));
    fu = Nucleus.Distance.Euclidean(),
    title_text = "",
)

    n_gr = lastindex(ng_)

    hi = hierarchize(Nucleus.Distance.get(fu, eachcol(fe_x_sa_x_nu)))

    un_ = unique(la_)

    la_x_ng_x_ti = Matrix{Int}(undef, lastindex(un_), n_gr)

    la_gr_ = Dict(la => Int[] for la in un_)

    for (idg, n_gr) in enumerate(ng_)

        for (la, gr) in zip(la_, cluster(hi, n_gr))

            push!(la_gr_[la], gr)

        end

        for (idl, la) in enumerate(un_)

            gr_ = la_gr_[la]

            la_x_ng_x_ti[idl, idg] = convert(Int, isone(lastindex(unique!(gr_))))

            empty!(gr_)

        end

    end

    me = _mean(la_x_ng_x_ti)

    id_ = sortperm(sum.(eachrow(la_x_ng_x_ti)))

    Nucleus.Plot.plot_heat_map(
        ht,
        la_x_ng_x_ti[id_, :];
        y = un_[id_],
        x = ng_,
        nar = "Label",
        nac = "Number of Group",
        layout = Dict(
            "title" => Dict("text" => "$title_text<br>$(Nucleus.Number.format4(me * 100))%"),
            "yaxis" => Dict("dtick" => 1),
            "xaxis" => Dict("dtick" => 1),
        ),
    )

    me

end

end
