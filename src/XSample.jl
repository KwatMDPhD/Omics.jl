module XSample

using DataFrames: dropmissing!

using StatsBase: mean

using ..Omics

function get_sample(ta, sa)

    ta[!, sa]

end

function get_sample(ta, sa::Regex)

    ta[!, findall(contains(sa), names(ta))[]]

end

function read_feature_sample(ts, fa, sa_)

    ta = dropmissing!(Omics.Table.rea(ts), fa)

    convert(Vector{String}, ta[!, fa]), stack((get_sample(ta, sa) for sa in sa_))

end

function select_non_nan(gr_, da, mi)

    re___ = [(id_, round(lastindex(id_) * mi)) for id_ in values(Omics.Dic.inde(gr_))]

    map(da_ -> all(re_ -> re_[2] <= sum(!isnan, da_[re_[1]]), re___), eachrow(da))

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

function index_feature(fe_, da, id_)

    fe_[id_], da[id_, :]

end

function rea(ts, fa, sa_; ta_ = ones(Int, lastindex(sa_)), mi = 1.0, lo = false)

    fe_, da = read_feature_sample(ts, fa, sa_)

    @info "Read $(lastindex(fe_))."

    fe_, da = index_feature(fe_, da, select_non_nan(ta_, da, mi))

    @info "Selected non-NaN $(lastindex(fe_))."

    if !allunique(fe_)

        fe_, da = collapse(mean, Float64, fe_, da)

        @info "Collapsed into $(lastindex(fe_))."

    end

    da___ = eachrow(da)

    if any(allequal, da___)

        fe_, da = index_feature(fe_, da, map(!allequal, da___))

        @info "Kept $(lastindex(fe_))."

    end

    if lo

        shift_log2!(da)

        @info "Log2ed."

    end

    fe_, da

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

end
