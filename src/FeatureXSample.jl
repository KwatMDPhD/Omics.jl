module FeatureXSample

using StatsBase: median

using ..Nucleus

# TODO: Test.
# TODO: Benchmark.
function remove_constant(la_, ma, di)

    # TODO: Benchmark `ea`.
    is_ = allequal.((isone(di) ? eachrow : eachcol)(ma))

    if any(is_)

        @warn "Removing $(sum(is_)) / $(lastindex(is_)) all-equal labels from dimension $di"

        is_ = .!is_

        la_ = la_[is_]

        ma = isone(di) ? ma[is_, :] : ma[:, is_]

    end

    la_, ma

end

function log_intersection(an___, it_)

    n = lastindex(it_)

    @info "👯 $(join((lastindex(an_) for an_ in an___), " ∩ ")) = $n." it_

    Nucleus.Error.error_0(n)

end

function count_unique(na_, an___)

    for (na, an_) in zip(na_, an___)

        @info "🔦 $na\n$(Nucleus.Collection.count_sort_string(an_))"

    end

end

function _plot(he, hi, nr, ro_, nc, co_, nn, nu; ke_ar...)

    title = Dict("title" => Dict("text" => nn))

    Nucleus.Plot.plot_heat_map(he, nu; y = ro_, x = co_, nr, nc, layout = title, ke_ar...)

    Nucleus.Plot.plot_histogram(hi, (vec(nu),); layout = Dict("xaxis" => title))

end

function transform(
    ro_,
    co_,
    nu;
    ro_r2 = Dict{String, String}(),
    fu = median,
    ty = Float64,
    lo = false,
    nr = "Feature",
    nc = "Sample",
    nn = "Number",
)

    _plot("", "", nr, ro_, nc, co_, nn, nu)

    tr_ = String[]

    if !isempty(ro_r2)

        # TODO: Generalize the "ENSG" logic.
        Nucleus.Gene.rename!(ro_, ro_r2)

        push!(tr_, "Renamed")

    end

    if !allunique(ro_)

        ro_, nu = Nucleus.Matrix.collapse(fu, ty, ro_, nu)

        push!(tr_, "Collapsed")

    end

    if lo

        nu .= log2.(nu .+ 1)

        push!(tr_, "+1Log2ed")

    end

    if !isempty(tr_)

        _plot("", "", nr, ro_, nc, co_, "$nn ($(join(tr_, " & ")))", nu)

    end

    ro_, nu

end

function write_plot(pr, nr, ro_, nc, co_, nn, nu; ke_ar...)

    Nucleus.Error.error_empty(pr)

    Nucleus.DataFrame.write("$pr.tsv", nr, ro_, co_, nu)

    _plot("$pr.html", "$pr.histogram.html", nr, ro_, nc, co_, nn, nu; ke_ar...)

end

end
