module XSampleFeature

using StatsBase: mean

using ..Omics

function collapse(fu, ty, f1_, n1)

    f1_i1_ = Omics.Dic.index(f1_)

    f2_ = sort!(collect(keys(f1_i1_)))

    n2 = Matrix{ty}(undef, lastindex(f2_), size(n1, 2))

    for i2 in eachindex(f2_)

        i1_ = f1_i1_[f2_[i2]]

        n2[i2, :] =
            isone(lastindex(i1_)) ? n1[i1_[], :] : [fu(v1_) for v1_ in eachcol(n1[i1_, :])]

    end

    f2_, n2

end

function process(
    fe_,
    nu;
    f1_f2 = Dict{String, String}(),
    vt_ = trues(size(nu, 2)),
    mi = 1.0,
    lo = false,
)

    fe_ = copy(fe_)

    nu = copy(nu)

    @info "Processing $(lastindex(fe_))"

    if any(isnan, nu)

        fe_, nu = Omics.XSampleSelect.index(fe_, nu, Omics.XSampleSelect.go(vt_, nu, mi))

        @info "Selected non-NaN $(lastindex(fe_))."

    end

    if !isempty(f1_f2)

        map!(fe -> Omics.Ma.ge(f1_f2, fe), fe_, fe_)

        Omics.Ma.lo(fe_)

    end

    if !allunique(fe_)

        fe_, nu = collapse(mean, Float64, fe_, nu)

        @info "Collapsed into $(lastindex(fe_))."

    end

    if any(allequal, eachrow(nu))

        fe_, nu = Omics.XSampleSelect.index(fe_, nu, map(!allequal, eachrow(nu)))

        @info "Kept nonconstant $(lastindex(fe_))."

    end

    if lo

        Omics.Normalization.shift_log2!(nu)

        @info "Shifted and logged."

    end

    fe_, nu

end

# TODO: vt_.
function writ(
    pr,
    nf,
    fe_,
    ns,
    sa_,
    nv,
    nu,
    vt_ = trues(size(nu, 2));
    la = Dict{String, Any}(),
)

    Omics.Table.writ("$pr.tsv", Omics.Table.make(nf, fe_, sa_, nu))

    Omics.Plot.plot_heat_map(
        "$pr.html",
        nu;
        ro_ = fe_,
        co_ = sa_,
        la = Omics.Dic.merg(
            Dict(
                "title" => Dict("text" => nv),
                "yaxis" => Dict("title" => "$nf ($(lastindex(fe_)))"),
                "xaxis" => Dict("title" => "$ns ($(lastindex(sa_)))"),
            ),
            la,
        ),
    )

    #Omics.Plot.plot(
    #    "$pr.histogram.html",
    #    (
    #        Dict(
    #            "type" => "histogram",
    #            "x" => vec(nu),
    #            "marker" => Dict("color" => Omics.Color.RE),
    #        ),
    #    ),
    #    Dict("yaxis" => Dict("title" => "Count"), "xaxis" => Dict("title" => nv)),
    #)

end

end
