module MatchPlot

using Distances: CorrDist, Euclidean

using ..Omics

function annotate!(an_, an, yc, id, te)

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

function prin(n1, n2)

    "$(Omics.Numbe.shorten(n1)) ($(Omics.Numbe.shorten(n2)))"

end

function annotate(om, he, te, bo, R)

    an = Dict(
        "yref" => "paper",
        "xref" => "paper",
        "yanchor" => "middle",
        "showarrow" => false,
    )

    yc = om + he * 0.392

    an_ =
        [merge(an, Dict("y" => yc, "x" => 0.5, "text" => te, "font" => Dict("size" => 16)))]

    if bo

        annotate!(an_, an, yc, 1, "Score (⧱)")

        annotate!(an_, an, yc, 2, "P Value (𝐪)")

    end

    yc = om - he * 0.5

    for (re, ma, pv, qv) in eachrow(R)

        annotate!(an_, an, yc, 1, prin(re, ma))

        annotate!(an_, an, yc, 2, prin(pv, qv))

        yc -= he

    end

    an_

end

const CO = Omics.Coloring.fractionate(("#0000ff", "#ffffff", "#ff0000"))

const OL = Dict(
    "x" => 0.5,
    "orientation" => "h",
    "len" => 0.56,
    "thickness" => 16,
    "outlinewidth" => 0,
    "title" => Dict("side" => "top"),
)

function trace(yc, te, xc_, nu_, st, um)

    Omics.Normalization.do_0_clamp!(nu_, st)

    mi, ma = eltype(nu_) <: AbstractFloat ? (-st, st) : extrema(nu_)

    om = 1.0 - inv(um)

    [
        Dict(
            "type" => "heatmap",
            "y" => (yc,),
            "x" => xc_,
            "z" => (nu_,),
            "zmin" => mi,
            "zmax" => ma,
            "colorscale" => CO,
            "colorbar" => merge(OL, Dict("y" => -0.32, "tickvals" => (mi, ma))),
        ),
    ],
    Dict(
        "height" => max(832, um * 40),
        "width" => 1280,
        "margin" => Dict("r" => 232),
        "yaxis" => Dict("domain" => (om, 1), "tickfont" => Dict("size" => 16)),
        "xaxis" =>
            Dict("side" => "top", "title" => Dict("text" => "$te ($(lastindex(xc_)))")),
        "annotations" => Dict{String, Any}[],
    ),
    om

end

function trace(te, yc_, xc_, N, st, R, id, o1, he)

    foreach(nu_ -> Omics.Normalization.do_0_clamp!(nu_, st), eachrow(N))

    mi, ma = eltype(N) <: AbstractFloat ? (-st, st) : extrema(N)

    bo = id == 2

    o2 = o1 - he

    o1 = o2 - he * lastindex(yc_)

    Dict(
        "yaxis" => "y$id",
        "type" => "heatmap",
        "y" => map(yc -> Omics.Strin.limit(yc, 40), yc_),
        "x" => xc_,
        "z" => collect(eachrow(N)),
        "zmin" => mi,
        "zmax" => ma,
        "colorscale" => CO,
        bo ? "colorbar" => merge(OL, Dict("y" => -0.456, "tickvals" => (mi, ma))) :
        "showscale" => false,
    ),
    Dict("yaxis$id" => Dict("domain" => (o1, o2), "autorange" => "reversed")),
    annotate(o2, he, te, bo, R),
    o1

end

function order(vt_, vf)

    Omics.Clustering.order(isone(size(vf, 1)) ? Euclidean() : CorrDist(), vt_, eachcol(vf))

end

function order(vt_::AbstractVector{<:AbstractFloat}, ::Any)

    eachindex(vt_)

end

function go(
    di,
    ns,
    sa_,
    nt,
    vt_,
    nf,
    fe_,
    vf,
    vr;
    u1 = 8,
    st = 3.0,
    la = Dict{String, Any}(),
)

    pr = joinpath(di, "result")

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(
            nf,
            fe_,
            ["Score", "95% Margin of Error", "P-Value", "Q-Value"],
            vr,
        ),
    )

    sc_ = vr[:, 1]

    ig_ = findall(!isnan, sc_)

    ix_ = ig_[reverse!(Omics.Extreme.ge(sc_[ig_], u1))]

    fe_ = fe_[ix_]

    vf = vf[ix_, :]

    vr = vr[ix_, :]

    io_ = order(vt_, vf)

    ur = 2 + lastindex(fe_)

    tr_, la, bo = trace(nt, ns, sa_[io_], vt_[io_], st, ur)

    tr, ya, an_, _ = trace(nf, fe_, sa_, vf[:, io_], st, vr, 2, bo, inv(ur))

    push!(tr_, tr)

    merge!(la, ya)

    append!(la["annotations"], an_)

    Omics.Plot.plot("$pr.html", tr_, la)

end

function go(ht, ns, sa_, nt, vt_, na___, nf___; st = 3.0, la = Dict{String, Any}())

    io_ = sortperm(vt_)

    ur = 1 + sum(nf_ -> 1 + lastindex(nf_[2]), nf___)

    tr_, la, bo = trace(nt, ns, sa_[io_], vt_[io_], st, ur)

    for ih in eachindex(nf___)

        nf, fe_ = nf___[ih]

        na_ = filter(na_ -> na_[1] == nf, na___)[]

        ie_ = indexin(fe_, na_[2])

        tr, ya, an_, bo =
            trace(nf, fe_, sa_, na_[3][ie_, io_], st, na_[4][ie_, :], 1 + ih, bo, inv(ur))

        push!(tr_, tr)

        merge!(la, ya)

        append!(la["annotations"], an_)

    end

    Omics.Plot.plot(ht, tr_, la)

end

end
