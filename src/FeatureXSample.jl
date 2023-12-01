module FeatureXSample

using StatsBase: median

using ..Nucleus

# TODO: Test.
function index_1(id_, ro_, ma)

    ro_[id_], ma[id_, :]

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

function plot(hte, hti, nar, ro_, nac, co_, nan, nu; ke_ar...)

    title = Dict("title" => Dict("text" => nan))

    Nucleus.Plot.plot_heat_map(hte, nu; y = ro_, x = co_, nar, nac, layout = title, ke_ar...)

    Nucleus.Plot.plot_histogram(hti, (vec(nu),); layout = Dict("xaxis" => title))

end

function plot(nar, ro_, nac, co_, nan, nu)

    plot("", "", nar, ro_, nac, co_, nan, nu)

end

function write_plot(pr, nar, ro_, nac, co_, nan, nu; ke_ar...)

    Nucleus.Error.error_empty(pr)

    Nucleus.DataFrame.write("$pr.tsv", nar, ro_, co_, nu)

    plot("$pr.html", "$pr.histogram.html", nar, ro_, nac, co_, nan, nu; ke_ar...)

end

function transform(
    ro_,
    co_,
    nu;
    ro_ro2 = Dict{String, String}(),
    fu = median,
    ty = Float64,
    lo = false,
    nar = "Feature",
    nac = "Sample",
    nan = "Number",
)

    _error_bad(ro_, co_, nu)

    plot(nar, ro_, nac, co_, nan, nu)

    tr_ = String[]

    if !isempty(ro_ro2)

        # TODO: Generalize the "ENSG" logic.
        Nucleus.Gene.rename!(ro_, ro_ro2)

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

        plot(nar, ro_, nac, co_, "$nan ($(join(tr_, " & ")))", nu)

    end

    ro_, nu

end

end
