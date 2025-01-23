module XSample

using OrderedCollections: OrderedDict

using StatsBase: countmap, mean

using ..Omics

function select_non_nan(ta_, da, mi)

    re___ = [(id_, round(lastindex(id_) * mi)) for id_ in values(Omics.Dic.inde(ta_))]

    findall(da_ -> all(re_ -> re_[2] <= sum(!isnan, da_[re_[1]]), re___), eachrow(da))

end

function rename!(fe_, fe_fa)

    ur = 0

    for id in eachindex(fe_)

        fe = fe_[id]

        fe_[id] = if haskey(fe_fa, fe)

            ur += 1

            fe_fa[fe]

        else

            "_$fe"

        end

    end

    uf = lastindex(fe_)

    @info "📛 Renamed $ur / $uf ($(ur / uf * 100)%)."

end

function collapse(fu, ty, fe_, da)

    fe_id_ = Omics.Dic.inde(fe_)

    fa_ = sort!(collect(keys(fe_id_)))

    dt = Matrix{ty}(undef, lastindex(fa_), size(da, 2))

    for ie in eachindex(fa_)

        id_ = fe_id_[fa_[ie]]

        dt[ie, :] = isone(lastindex(id_)) ? da[id_[], :] : map(fu, eachcol(da[id_, :]))

    end

    fa_, dt

end

function shift_log2!(da)

    mi = minimum(da)

    map!(da -> log2(da - mi + 1), da, da)

end

function _index_feature(fe_, da, id_)

    fe_[id_], da[id_, :]

end

function process!(
    fe_,
    da;
    fe_fa = Dict{String, String}(),
    ta_ = trues(size(da, 2)),
    mi = 1.0,
    lo = false,
)

    @info "Processing $(lastindex(fe_))"

    if any(isnan, da)

        fe_, da = _index_feature(fe_, da, select_non_nan(ta_, da, mi))

        @info "Selected non-NaN $(lastindex(fe_))."

    end

    if !isempty(fe_fa)

        rename!(fe_, fe_fa)

    end

    if !allunique(fe_)

        fe_, da = collapse(mean, Float64, fe_, da)

        @info "Collapsed into $(lastindex(fe_))."

    end

    da___ = eachrow(da)

    if any(allequal, da___)

        fe_, da = _index_feature(fe_, da, findall(!allequal, da___))

        @info "Kept nonconstant $(lastindex(fe_))."

    end

    if lo

        shift_log2!(da)

        @info "Log2ed."

    end

    fe_, da

end

function _count_sort_string(an_, mi = 1)

    an_na = countmap(an_)

    join(
        "$(rpad(na, 8))$an.\n" for
        (an, na) in sort(an_na; by = an -> (an_na[an], an)) if mi <= na
    )

end

function _log_unique(na_, an___)

    for id in sortperm(an___; by = an_ -> lastindex(unique(an_)), rev = true)

        @info "🔦 ($id) $(na_[id])\n$(_count_sort_string(an___[id]))"

    end

end

function write_plot(pr, nf, fe_, ns, sa_, nd, da)

    Omics.Table.writ("$pr.tsv", Omics.Table.make(nf, fe_, sa_, da))

    Omics.Plot.plot_heat_map(
        "$pr.html",
        da;
        ro_ = fe_,
        co_ = sa_,
        la = Dict(
            "title" => Dict("text" => nd),
            "yaxis" => Dict("title" => Omics.Strin.coun(lastindex(fe_), nf)),
            "xaxis" => Dict("title" => Omics.Strin.coun(lastindex(sa_), ns)),
        ),
    )

    Omics.Plot.plot(
        "$pr.histogram.html",
        (
            Dict(
                "type" => "histogram",
                "x" => vec(da),
                "marker" => Dict("color" => Omics.Color.RE),
            ),
        ),
        Dict("yaxis" => Dict("title" => "Count"), "xaxis" => Dict("title" => nd)),
    )

end

function write_plot(di, ns, sa_, ch_, vc, nf, fe_, vf, nt, ps_, pf_)

    ts = joinpath(di, "$ns.tsv")

    Omics.Table.writ(ts, Omics.Table.make("Characteristic", ch_, sa_, vc))

    _log_unique(ch_, eachrow(vc))

    pr = joinpath(di, "$ns.$nf")

    write_plot(pr, nf, fe_, ns, sa_, "Value", vf)

    Omics.Dic.writ(
        joinpath(di, "$ns.json"),
        OrderedDict(
            "Characteristic" => ts,
            "Feature" => "$pr.tsv",
            "Peek Sample" => ps_,
            "Peek Feature" => pf_,
            "Target" => nt,
        ),
    )

end

function joi(fi, f1_, s1_, d1, f2_, s2_, d2)

    f3_ = union(f1_, f2_)

    s3_ = union(s1_, s2_)

    d3 = fill(fi, lastindex(f3_), lastindex(s3_))

    fe_id = Omics.Dic.index(f3_)

    sa_id = Omics.Dic.index(s3_)

    for is in eachindex(s1_)

        ia = sa_id[s1_[is]]

        for ie in eachindex(f1_)

            d3[fe_id[f1_[ie]], ia] = d1[ie, is]

        end

    end

    for is in eachindex(s2_)

        ia = sa_id[s2_[is]]

        for ie in eachindex(f2_)

            d3[fe_id[f2_[ie]], ia] = d2[ie, is]

        end

    end

    f3_, s3_, d3

end

end
