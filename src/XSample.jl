module XSample

using OrderedCollections: OrderedDict

using StatsBase: mean

using ..Omics

# TODO: Generalize.
function coun(he::AbstractString, vc_)

    bo = join(
        "$uu $un.\n" for (uu, un) in sort(map(un -> (count(==(un), vc_), un), unique(vc_)))
    )

    @info "$he\n$bo"

end

# TODO: Generalize.
function coun(ch_, vc___)

    for id in sortperm(vc___; by = an_ -> lastindex(unique(an_)), rev = true)

        coun("🔦 ($id) $(ch_[id])", vc___[id])

    end

end

# TODO: Generalize.
function standardize_clamp!(va_, st)

    if allequal(va_)

        @warn "All values are $(va_[1])."

        fill!(va_, 0.0)

    else

        Omics.Normalization.normalize_with_0!(va_)

        clamp!(va_, -st, st)

    end

end

# TODO: Generalize.
function standardize_clamp!(::AbstractVector{<:Integer}, ::Any) end

function rea(ta, nf, sa_)

    na_ = names(ta)

    ta[!, nf], Matrix(ta[!, map(sa -> findall(contains(sa), na_)[], sa_)])

end

function select_non_nan(vt_, vf, mi)

    is___ = map(un -> findall(==(un), vt_), unique(vt_))

    mi_ = map(is_ -> lastindex(is_) * mi, is___)

    map(
        vf_ -> all(iu -> mi_[iu] <= sum(!isnan, view(vf_, is___[iu])), eachindex(is___)),
        eachrow(vf),
    )

end

function rename!(f1_, f1_f2)

    u2 = 0

    for id in eachindex(f1_)

        f1 = f1_[id]

        f1_[id] = if haskey(f1_f2, f1)

            u2 += 1

            f1_f2[f1]

        else

            "_$f1"

        end

    end

    u1 = lastindex(f1_)

    @info "📛 Renamed $u2 / $u1 ($(u2 / u1 * 100)%)."

end

function collapse(fu, ty, f1_, v1)

    f1_i1_ = Omics.Dic.inde(f1_)

    f2_ = sort!(collect(keys(f1_i1_)))

    v2 = Matrix{ty}(undef, lastindex(f2_), size(v1, 2))

    for i2 in eachindex(f2_)

        i1_ = f1_i1_[f2_[i2]]

        v2[i2, :] =
            isone(lastindex(i1_)) ? v1[i1_[], :] : [fu(v1_) for v1_ in eachcol(v1[i1_, :])]

    end

    f2_, v2

end

function shift_log2!(vf)

    mi = minimum(vf)

    map!(va -> log2(va - mi + 1), vf, vf)

end

function _index_feature(fe_, vf, id_)

    fe_[id_], vf[id_, :]

end

function process(
    fe_,
    vf;
    f1_f2 = Dict{String, String}(),
    vt_ = trues(size(vf, 2)),
    mi = 1.0,
    lo = false,
)

    fe_ = copy(fe_)

    vf = copy(vf)

    @info "Processing $(lastindex(fe_))"

    if any(isnan, vf)

        fe_, vf = _index_feature(fe_, vf, select_non_nan(vt_, vf, mi))

        @info "Selected non-NaN $(lastindex(fe_))."

    end

    if !isempty(f1_f2)

        rename!(fe_, f1_f2)

    end

    if !allunique(fe_)

        fe_, vf = collapse(mean, Float64, fe_, vf)

        @info "Collapsed into $(lastindex(fe_))."

    end

    vf___ = eachrow(vf)

    if any(allequal, vf___)

        fe_, vf = _index_feature(fe_, vf, findall(!allequal, vf___))

        @info "Kept nonconstant $(lastindex(fe_))."

    end

    if lo

        shift_log2!(vf)

        @info "Log2ed."

    end

    fe_, vf

end

function write_plot(pr, nf, fe_, ns, sa_, nv, vf)

    Omics.Table.writ("$pr.tsv", Omics.Table.make(nf, fe_, sa_, vf))

    Omics.Plot.plot_heat_map(
        "$pr.html",
        vf;
        ro_ = fe_,
        co_ = sa_,
        la = Dict(
            "title" => Dict("text" => nv),
            "yaxis" => Dict("title" => "$nf ($(lastindex(fe_)))"),
            "xaxis" => Dict("title" => "$ns ($(lastindex(sa_)))"),
        ),
    )

    Omics.Plot.plot(
        "$pr.histogram.html",
        (
            Dict(
                "type" => "histogram",
                "x" => vec(vf),
                "marker" => Dict("color" => Omics.Color.RE),
            ),
        ),
        Dict("yaxis" => Dict("title" => "Count"), "xaxis" => Dict("title" => nv)),
    )

end

function write_plot(di, ns, sa_, ch_, vc, nf, fe_, vf, nt, ps_, pf_)

    ts = joinpath(di, "$ns.ch.tsv")

    Omics.Table.writ(ts, Omics.Table.make("Characteristic", ch_, sa_, vc))

    coun(ch_, eachrow(vc))

    pr = joinpath(di, "$ns.fe")

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

function align(s1_, v1, s2_, v2, sa_ = s1_)

    it_ = intersect(s1_, s2_)

    i1_ = indexin(it_, s1_)

    i2_ = indexin(it_, s2_)

    sa_[i1_], v1[:, i1_], v2[:, i2_]

end

function joi(fi, f1_, s1_, v1, f2_, s2_, v2)

    f3_ = union(f1_, f2_)

    s3_ = union(s1_, s2_)

    v3 = fill(fi, lastindex(f3_), lastindex(s3_))

    f3_id = Omics.Dic.index(f3_)

    s3_id = Omics.Dic.index(s3_)

    for is in eachindex(s1_)

        i3 = s3_id[s1_[is]]

        for ie in eachindex(f1_)

            v3[f3_id[f1_[ie]], i3] = v1[ie, is]

        end

    end

    for is in eachindex(s2_)

        i3 = s3_id[s2_[is]]

        for ie in eachindex(f2_)

            v3[f3_id[f2_[ie]], i3] = v2[ie, is]

        end

    end

    f3_, s3_, v3

end

end
