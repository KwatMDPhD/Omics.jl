module MatchPlot

using Distances: CorrDist, Euclidean

using ..Omics

function layout(um, te, u2)

    Dict(
        "height" => max(832, um * 40),
        "width" => 1280,
        "margin" => Dict("r" => 232),
        "xaxis" => Dict("side" => "top", "title" => Dict("text" => "$te ($u2)")),
    )

end

function pus!(an_, an, yc, id, te)

    push!(
        an_,
        merge(
            an,
            Dict(
                "y" => yc,
                "x" => isone(id) ? 1.016 : 1.128,
                "xanchor" => "left",
                "text" => te,
            ),
        ),
    )

end

function strin(n1, n2)

    "$(Omics.Numbe.shorten(n1)) ($(Omics.Numbe.shorten(n2)))"

end

function annotate(y1, he, te, bo, R)

    an = Dict(
        "yref" => "paper",
        "xref" => "paper",
        "yanchor" => "middle",
        "showarrow" => false,
    )

    y2 = y1 + he * 0.392

    an_ =
        [merge(an, Dict("y" => y2, "x" => 0.5, "text" => te, "font" => Dict("size" => 16)))]

    if bo

        pus!(an_, an, y2, 1, "Score (⧱)")

        pus!(an_, an, y2, 2, "P Value (𝐪)")

    end

    y2 = y1 - he * 0.5

    for (re, ma, pv, qv) in eachrow(R)

        pus!(an_, an, y2, 1, strin(re, ma))

        pus!(an_, an, y2, 2, strin(pv, qv))

        y2 -= he

    end

    an_

end

function get_extrema(nu_::AbstractArray{<:AbstractFloat}, st::Real)

    -st, st

end

function get_extrema(nu_, ::Real)

    extrema(nu_)

end

const CO = Dict(
    "x" => 0.5,
    "orientation" => "h",
    "len" => 0.56,
    "thickness" => 16,
    "outlinewidth" => 0,
)

function trace(nu_, st, yc, te, xc_, he)

    co_ = copy(nu_)

    Omics.Normalization.do_0_clamp!(co_, st)

    mi, ma = get_extrema(co_, st)

    om = 1.0 - he

    [
        Dict(
            "type" => "heatmap",
            "y" => (yc,),
            "x" => xc_,
            "z" => (co_,),
            "text" => (nu_,),
            "zmin" => mi,
            "zmax" => ma,
            "colorscale" => Omics.Plot.CO,
            "colorbar" => merge(CO, Dict("y" => -0.32, "tickvals" => (mi, ma))),
        ),
    ],
    Dict("domain" => (om, 1), "tickfont" => Dict("size" => 16)),
    om

end

function trace(N, st, te, yc_, xc_, R, id, o1, he)

    C = copy(N)

    foreach(nu_ -> Omics.Normalization.do_0_clamp!(nu_, st), eachrow(C))

    mi, ma = get_extrema(C, st)

    bo = id == 2

    o2 = o1 - he

    o1 = o2 - he * lastindex(yc_)

    Dict(
        "yaxis" => "y$id",
        "type" => "heatmap",
        "y" => map(yc -> Omics.Strin.limit(yc, 40), yc_),
        "x" => xc_,
        "z" => collect(eachrow(C)),
        "text" => collect(eachrow(N)),
        "zmin" => mi,
        "zmax" => ma,
        "colorscale" => Omics.Plot.CO,
        bo ? "colorbar" => merge(CO, Dict("y" => -0.456, "tickvals" => (mi, ma))) :
        "showscale" => false,
    ),
    Dict("domain" => (o1, o2), "autorange" => "reversed"),
    annotate(o2, he, te, bo, R),
    o1

end

function order(nu_::AbstractVector{<:AbstractFloat}, ::AbstractMatrix)

    sortperm(nu_)

end

function order(nu_, N)

    Omics.Clustering.order(isone(size(N, 1)) ? Euclidean() : CorrDist(), nu_, eachcol(N))

end

function writ(
    pr,
    a1,
    xc_,
    a2,
    nu_,
    a3,
    yc_,
    N,
    R;
    u1 = 8,
    st = 3.0,
    la = Dict{String, Any}(),
)

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(
            a3,
            yc_,
            ["Score", "95% Margin of Error", "P-Value", "Q-Value"],
            R,
        ),
    )

    re_ = R[:, 1]

    i1_ = findall(!isnan, re_)

    i1_ = i1_[reverse!(Omics.Extreme.ge(re_[i1_], u1))]

    yc_ = yc_[i1_]

    N = N[i1_, :]

    R = R[i1_, :]

    i2_ = order(nu_, N)

    xc_ = xc_[i2_]

    u2 = 2 + lastindex(yc_)

    he = inv(u2)

    la = layout(u2, a1, lastindex(xc_))

    tr_, la["yaxis"], om = trace(nu_[i2_], st, a2, a1, xc_, he)

    tr, la["yaxis2"], la["annotations"], _ =
        trace(N[:, i2_], st, a3, yc_, xc_, R, 2, om, he)

    push!(tr_, tr)

    Omics.Plot.plot("$pr.html", tr_, la)

end

function writ(ht, a1, xc_, a2, nu_, aa__, bb__; st = 3.0, la = Dict{String, Any}())

    id_ = sortperm(nu_)

    xc_ = xc_[id_]

    um = 1 + sum(bb_ -> 1 + lastindex(bb_[2]), bb__)

    he = inv(um)

    la = layout(um, a1, lastindex(xc_))

    la["annotations"] = Dict{String, Any}[]

    tr_, la["yaxis"], om = trace(nu_[id_], st, a2, a1, xc_, he)

    for i1 in eachindex(bb__)

        a3, yc_ = bb__[i1]

        aa_ = filter(aa_ -> aa_[1] == a3, aa__)[]

        i2_ = indexin(yc_, aa_[2])

        i3 = 1 + i1

        tr, la["yaxis$i3"], an_, om =
            trace(aa_[3][i2_, id_], st, a3, yc_, xc_, aa_[4][i2_, :], i3, om, he)

        push!(tr_, tr)

        append!(la["annotations"], an_)

    end

    Omics.Plot.plot(ht, tr_, la)

end

end
