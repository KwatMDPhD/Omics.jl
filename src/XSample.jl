module XSample

using StatsBase: mean

using ..Omics

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

function select_non_nan(ta_, da, mi)

    re___ = [(id_, round(lastindex(id_) * mi)) for id_ in values(Omics.Dic.inde(ta_))]

    findall(da_ -> all(re_ -> re_[2] <= sum(!isnan, da_[re_[1]]), re___), eachrow(da))

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

function index_feature(fe_, da, id_)

    fe_[id_], da[id_, :]

end

function shift_log2!(da)

    mi = minimum(da)

    map!(da -> log2(da - mi + 1), da, da)

end

function rename_collapse_log(fe_, fs; fe_f2 = Dict{String, String}(), lo = false)
    fe_ = copy(fe_)
    fs = copy(fs)
    if !isempty(fe_f2)
        Nucleus.Collection.rename!(fe_, fe_f2)
        id_ = findall(fe -> !isempty(fe) && fe[1] != '_', fe_)
        ug = lastindex(id_)
        if ug < lastindex(fe_)
            fe_ = fe_[id_]
            fs = fs[id_, :]
            @warn "Kept $ug."
        end
    end
    if !allunique(fe_)
        fe_, fs = Nucleus.Matrix.collapse(median, Float64, fe_, fs)
    end
    if lo
        shift_log!(fs)
    end
    fe_, fs
end

function process(
    fe_,
    da;
    fe_fa = Dict{String, String}(),
    ta_ = trues(size(da, 2)),
    mi = 1.0,
    lo = false,
)

    @info "Processing $(lastindex(fe_))"

    if !isempty(fe_fa)

        rename!(fe_, fe_fa)

    end

    if any(isnan, da)

        fe_, da = index_feature(fe_, da, select_non_nan(ta_, da, mi))

        @info "Selected non-NaN $(lastindex(fe_))."

    end

    if !allunique(fe_)

        fe_, da = collapse(mean, Float64, fe_, da)

        @info "Collapsed into $(lastindex(fe_))."

    end

    da___ = eachrow(da)

    if any(allequal, da___)

        fe_, da = index_feature(fe_, da, findall(!allequal, da___))

        @info "Kept $(lastindex(fe_))."

    end

    if lo

        shift_log2!(da)

        @info "Log2ed."

    end

    fe_, da

end

function write(di, ns, sa_, ir_, is, nf, fe_, fs, ir, ps_, pf_)

    ts = Nucleus.Path.clean(joinpath(di, "information_x_$(ns)_x_any.tsv"))
    ke_ar = if isempty(ir)
        ()
    else
        la_ = is[findfirst(==(ir), ir_), :]
        is_ = isempty.(la_)
        if any(is_)
            st = Nucleus.String.count(sum(is_), "sample")
            @warn "Removing $st with an empty \"$ir\"\n$(join(sa_[is_], '\n'))."
            is_ .= .!is_
            sa_ = sa_[is_]
            is = is[:, is_]
            fs = fs[:, is_]
            la_ = la_[is_]
        end
        (gc_ = la_,)
    end
    Nucleus.DataFrame.write(ts, "Information", ir_, sa_, is)
    Nucleus.Collection.log_unique(ir_, eachrow(is))
    pr = joinpath(di, "$(nf)_x_$(ns)_x_number")
    write_plot(pr, nf, fe_, ns, sa_, basename(di), fs; ke_ar...)
    Nucleus.Dict.write(
        joinpath(di, "$(Nucleus.Path.clean(ns)).json"),
        OrderedDict(
            "information_tsv" => ts,
            "feature_tsv" => "$(Nucleus.Path.clean(pr)).tsv",
            "peek_sample" => ps_,
            "peek_feature" => pf_,
            "target" => ir,
        ),
    )
    sa_, ir_, is, nf, fe_, fs

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
