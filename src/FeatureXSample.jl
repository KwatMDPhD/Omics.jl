module FeatureXSample

using StatsBase: median

using ..Nucleus

function initialize_block()

    String[], String[], Vector{String}[], Vector{String}[], Matrix[]

end

function push_block!(ts_, nar_, ro___, co___, ma_, ts, nar, ro_, co_, ma)

    push!(ts_, ts)

    push!(nar_, nar)

    push!(ro___, ro_)

    push!(co___, co_)

    push!(ma_, ma)

    nothing

end

function _error_0(n)

    if iszero(n)

        error("0.")

    end

end

function _log_intersection(an___, it_)

    n = lastindex(it_)

    @info "$(join((lastindex(an_) for an_ in an___), " ∩ ")) = $n." it_

    _error_0(n)

end

function intersect_column!(co___, ma_)

    it_ = intersect(co___...)

    _log_intersection(co___, it_)

    for (id, (co_, ma)) in enumerate(zip(co___, ma_))

        ma_[id] = ma[:, indexin(it_, co_)]

    end

    it_

end

# TODO: Remove.
function intersect_column(co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an)

    ma_ = [ro_x_co1_x_an, ro_x_co2_x_an]

    it_ = intersect_column!((co1_, co2_), ma_)

    it_, ma_...

end

function write_block(ts_, nar_, ro___, co_, ma_)

    for (ts, nar, ro_, ma) in zip(ts_, nar_, ro___, ma_)

        Nucleus.DataFrame.write(ts, nar, ro_, co_, ma)

        @info ts nar ro_ co_ ma

    end

end

function count_unique(na_, an___)

    for (na, an_) in zip(na_, an___)

        @info "$na\n$(Nucleus.Collection.count_sort_string(an_))"

    end

end

function _plot(ro_x_co_x_nu, ro_, co_, nar, nac, nan)

    layout = Dict("title" => Dict("text" => nan))

    Nucleus.Plot.plot_heat_map("", ro_x_co_x_nu; y = ro_, x = co_, nar, nac, layout)

    Nucleus.Plot.plot_histogram("", (vec(ro_x_co_x_nu),); layout)

end

function transform(
    ro_,
    co_,
    ro_x_co_x_nu;
    ro_ro2 = Dict{String, String}(),
    fu = median,
    ty = Float64,
    lo = false,
    nar = "Row",
    nac = "Column",
    nan = "Number",
)

    Nucleus.Error.error_bad(isnothing, ro_)

    Nucleus.Error.error_bad(ismissing, ro_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, ro_)

    Nucleus.Error.error_duplicate(co_)

    Nucleus.Error.error_bad(isnothing, co_)

    Nucleus.Error.error_bad(ismissing, co_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, co_)

    Nucleus.Error.error_bad(isnothing, ro_x_co_x_nu)

    Nucleus.Error.error_bad(ismissing, ro_x_co_x_nu)

    Nucleus.Error.error_bad(!isfinite, ro_x_co_x_nu)

    _plot(ro_x_co_x_nu, ro_, co_, nar, nac, nan)

    if !isempty(ro_ro2)

        # TODO: Generalize the "ENSG" logic.
        Nucleus.Gene.rename!(ro_, ro_ro2)

    end

    if !allunique(ro_)

        ro_, ro_x_co_x_nu = Nucleus.Matrix.collapse(fu, ty, ro_, ro_x_co_x_nu)

    end

    if lo

        ro_x_co_x_nu .= log2.(ro_x_co_x_nu .+ 1)

    end

    _plot(ro_x_co_x_nu, ro_, co_, nar, nac, "$nan (Final)")

    ro_, ro_x_co_x_nu

end

end
