module FeatureXSample

using StatsBase: median

using ..Nucleus

# TODO: Test.
function remove_constant(la_, ma)

    nl = lastindex(la_)

    n1, n2 = size(ma)

    if nl == n1 == n2

        error()

    elseif nl == n1

        ea = eachrow

        di = 1

    elseif nl == n2

        ea = eachcol

        di = 2

    else

        error()

    end

    is_ = allequal.(ea(ma))

    if any(is_)

        @warn "Removing $(sum(is_)) / $nl all-equal labels from dimension $di"

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

function _error_bad(ro_, co_, nu)

    Nucleus.Error.error_bad(isnothing, ro_)

    Nucleus.Error.error_bad(ismissing, ro_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, ro_)

    Nucleus.Error.error_duplicate(co_)

    Nucleus.Error.error_bad(isnothing, co_)

    Nucleus.Error.error_bad(ismissing, co_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, co_)

    Nucleus.Error.error_bad(isnothing, nu)

    Nucleus.Error.error_bad(ismissing, nu)

    Nucleus.Error.error_bad(!isfinite, nu)

end

function plot(he, hi, nr, ro_, nc, co_, nn, nu; ke_ar...)

    title = Dict("title" => Dict("text" => nn))

    Nucleus.Plot.plot_heat_map(he, nu; y = ro_, x = co_, nr, nc, layout = title, ke_ar...)

    Nucleus.Plot.plot_histogram(hi, (vec(nu),); layout = Dict("xaxis" => title))

end

function plot(nr, ro_, nc, co_, nn, nu; ke_ar...)

    plot("", "", nr, ro_, nc, co_, nn, nu; ke_ar...)

end

function write_plot(pr, nr, ro_, nc, co_, nn, nu; ke_ar...)

    Nucleus.Error.error_empty(pr)

    Nucleus.DataFrame.write("$pr.tsv", nr, ro_, co_, nu)

    plot("$pr.html", "$pr.histogram.html", nr, ro_, nc, co_, nn, nu; ke_ar...)

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

    _error_bad(ro_, co_, nu)

    plot(nr, ro_, nc, co_, nn, nu)

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

        plot(nr, ro_, nc, co_, "$nn ($(join(tr_, " & ")))", nu)

    end

    ro_, nu

end

end
