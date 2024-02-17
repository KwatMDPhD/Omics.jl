module FeatureXSample

using StatsBase: median

using ..Nucleus

function log_unique(na_, an___)

    for (na, an_) in zip(na_, an___)

        @info "🔦 $na\n$(Nucleus.Collection.count_sort_string(an_))"

    end

end

function log_intersection(an___, it_)

    ni = lastindex(it_)

    @info "👯 $(join((lastindex(an_) for an_ in an___), " ∩ ")) = $ni." it_

    Nucleus.Error.error_0(ni)

end

# TODO: Test.
# TODO: Benchmark.
function remove_constant(la_, ma, di)

    # TODO: Benchmark `ea`.
    is_ = allequal.((isone(di) ? eachrow : eachcol)(ma))

    if any(is_)

        @warn "Removing $(sum(is_)) / $(lastindex(is_)) all-equals from dimension $di"

        is_ = .!is_

        la_ = la_[is_]

        ma = isone(di) ? ma[is_, :] : ma[:, is_]

    end

    la_, ma

end

# TODO: Test.
# TODO: Benchmark.
function assimilate(c1_, c2_, m2)

    ma = Matrix{Union{Missing, eltype(m2)}}(undef, size(m2, 1), lastindex(c1_))

    for (i1, c1) in enumerate(c1_)

        i2_ = findall(==(c1), c2_)

        n2 = lastindex(i2_)

        if iszero(n2)

            @warn "$c1 ($i1) is missing."

            ma[:, i1] .= missing

        elseif isone(n2)

            ma[:, i1] = m2[:, i2_[1]]

        end

    end

    ma

end

function rename_collapse(ro_, rc, ro_r2, fu = median, ty = Float64)

    # TODO: Generalize the "ENSG" logic.
    r2_ = Nucleus.Gene.rename(ro_, ro_r2)

    if !allunique(r2_)

        r2_, rc = Nucleus.Matrix.collapse(fu, ty, r2_, rc)

    end

    r2_, rc

end

function write_plot(pr, nr, ro_, nc, co_, nn, rc; ke_ar...)

    Nucleus.Error.error_empty(pr)

    Nucleus.DataFrame.write("$pr.tsv", nr, ro_, co_, rc)

    title = Dict("title" => Dict("text" => nn))

    Nucleus.Plot.plot_heat_map("$pr.html", rc; y = ro_, x = co_, nr, nc, layout = title, ke_ar...)

    Nucleus.Plot.plot_histogram("$pr.histogram.html", (vec(rc),); layout = Dict("xaxis" => title))

end

end
