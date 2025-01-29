module Kumo

using LinearAlgebra: norm

using OrderedCollections: OrderedSet

using StatsBase: mean

using ..Omics

# TODO: Generalize.
const TR_ = 0.866, 0.5, -0.866, 0.5, 0, -1

const NO_ = OrderedSet{String}()

const CL___ = Tuple{Vararg{String}}[]

const ED_ = OrderedSet{Tuple{String, String}}()

function clear!()

    empty!(NO_)

    empty!(CL___)

    empty!(ED_)

end

function _add_node!(an, cl_ = ())

    no = string(an)

    if no in NO_

        @warn "\"$no\" exists."

    else

        push!(NO_, no)

        push!(CL___, cl_)

    end

end

function _add_edge!(a1, a2)

    ed = (string(a1), string(a2))

    for no in ed

        if !(no in NO_)

            error("\"$no\" doet not exist.")

        end

    end

    if ed in ED_

        @warn "`$ed` exists."

    else

        push!(ED_, ed)

    end

end

function _add_edge!(a1_::Tuple, a2)

    for a1 in a1_

        _add_edge!(a1, a2)

    end

end

function _add_edge!(a1, a2_::Tuple)

    for a2 in a2_

        _add_edge!(a1, a2)

    end

end

function _add_edge!(a1_::Tuple, a2_::Tuple)

    for a1 in a1_, a2 in a2_

        _add_edge!(a1, a2)

    end

end

function _make_how_node(a1, ho)

    "$a1.$ho"

end

function _make_how_node(a1_::Tuple, ho)

    _make_how_node(join(a1_, '_'), ho)

end

function _add_edge!(a1, ho, a2)

    no = _make_how_node(a1, ho)

    _add_node!(no)

    _add_edge!(a1, no)

    _add_edge!(no, a2)

end

macro st(sy, cl_...)

    se = esc(sy)

    quote

        struct $se end

        _add_node!($se, $(map(string, cl_)))

    end

end

function <<(a1, a2)

    _add_edge!(a1, "de", a2)

end

function >>(a1, a2)

    _add_edge!(a1, "in", a2)

end

function report()

    ud = ui = 0

    for no in NO_

        if endswith(no, ".de")

            ud += 1

        elseif endswith(no, ".in")

            ui += 1

        end

    end

    @info "$(Omics.Strin.count(length(NO_), "node")) ($(sum(!isempty, CL___)) classed, $ud decreasing, and $ui increasing)." NO_

    @info "$(Omics.Strin.count(length(ED_), "edge"))." ED_

end

function _elementize(no, cl_)

    de = '.'

    Dict(
        "data" => Dict("id" => no, "weight" => 0),
        "classes" => if contains(no, de)
            ("ho", Omics.Strin.split_get(no, de, 2), cl_...)
        else
            ("no", cl_...)
        end,
    )

end

function _elementize(ed)

    Dict("data" => Dict("source" => ed[1], "target" => ed[2]))

end

function plot(
    ht;
    ep_ = Dict{String, Any}[],
    he_ = Float64[],
    st_ = Dict{String, Any}[],
    s1 = 24,
    ex = "",
)

    en_ = map(_elementize, NO_, CL___)

    if !isempty(ep_)

        Omics.Cytoscape.position!(en_, ep_)

    end

    if !isempty(he_)

        for id in eachindex(en_)

            en = en_[id]

            he = he_[id]

            en["data"]["weight"] = he

            push!(
                st_,
                Dict(
                    "selector" => "#$(en["data"]["id"])",
                    "style" => Dict(
                        "background-color" =>
                            Omics.Palette.color(he, Omics.Palette.bwr)[1:7],
                    ),
                ),
            )

        end

    end

    s2 = s1 * 0.64

    ga = s1 * 0.16

    h0 = Omics.Color.DA

    h1 = Omics.Color.TU

    Omics.Cytoscape.plot(
        ht,
        vcat(en_, _elementize.(ED_));
        st_ = append!(
            [
                Dict(
                    "selector" => "node",
                    "style" => Dict(
                        "border-width" => 1.6,
                        "border-color" => Omics.Color.LI,
                        "font-size" => s1 * 0.64,
                    ),
                ),
                Dict(
                    "selector" => ".no",
                    "style" => Dict("height" => s1, "width" => s1, "label" => "data(id)"),
                ),
                Dict(
                    "selector" => ".ho",
                    "style" => Dict("shape" => "polygon", "height" => s2, "width" => s2),
                ),
                Dict(
                    "selector" => ".de",
                    "style" => Dict(
                        "shape-polygon-points" => map(co -> -co, TR_),
                        "background-color" => Omics.Color.AY,
                    ),
                ),
                Dict(
                    "selector" => ".in",
                    "style" => Dict(
                        "shape-polygon-points" => TR_,
                        "background-color" => Omics.Color.AG,
                    ),
                ),
                Dict(
                    "selector" => ".nodehover",
                    "style" => Dict(
                        "border-style" => "double",
                        "border-color" => h1,
                        "label" => "data(weight)",
                    ),
                ),
                Dict(
                    "selector" => "edge",
                    "style" => Dict(
                        "source-distance-from-node" => ga,
                        "target-distance-from-node" => ga,
                        "curve-style" => "bezier",
                        "width" => s1 * 0.08,
                        "line-opacity" => 0.64,
                        "line-fill" => "linear-gradient",
                        "line-gradient-stop-colors" => ("#ffffff", h0),
                        "target-arrow-shape" => "triangle-backcurve",
                        "arrow-scale" => 1.64,
                        "target-arrow-color" => h0,
                    ),
                ),
                Dict(
                    "selector" => ".edgehover",
                    "style" => Dict(
                        "line-opacity" => 1,
                        "line-gradient-stop-colors" => ("#ffffff", h1),
                        "target-arrow-color" => h1,
                    ),
                ),
            ],
            st_,
        ),
        la = if isempty(ep_)
            Dict(
                "name" => "cose",
                "padding" => 16,
                #"boundingBox" => Dict("y1" => 0, "x1" => 0, "h" => hi, "w" => wi),
                "componentSpacing" => 40,
                "nodeRepulsion" => 8000,
                "idealEdgeLength" => 16,
                "numIter" => 10000,
            )
        else
            Dict("name" => "preset")
        end,
        ex,
    )

end

# TODO: Consider `+1`.
function heat(fe_sc; no_al_ = Dict{String, Vector{String}}())

    he_ = zeros(length(NO_))

    for id in eachindex(NO_)

        no = NO_[id]

        if contains(no, '.')

            continue

        end

        if haskey(fe_sc, no)

            he_[id] = fe_sc[no]

        else

            sc_ = Float64[]

            for al in no_al_[no]

                if haskey(fe_sc, al)

                    push!(sc_, fe_sc[al])

                end

            end

            if !isempty(sc_)

                he_[id] = mean(sc_)

            end

        end

    end

    he_

end

function heat(fe_, fe_x_sa_x_sc; ke_ar...)

    no_x_sa_x_he = Matrix{Float64}(undef, length(NO_), size(fe_x_sa_x_sc, 2))

    if lastindex(fe_) != size(fe_x_sa_x_sc, 1)

        error("Numbers of features differ.")

    end

    for (id, sc_) in enumerate(eachcol(fe_x_sa_x_sc))

        no_x_sa_x_he[:, id] = heat(Dict(zip(fe_, sc_)); ke_ar...)

    end

    no_x_sa_x_he

end

function make_edge_matrix()

    n = length(NO_)

    so_x_ta_x_ed = falses(n, n)

    no_id = Dict(no => id for (id, no) in enumerate(NO_))

    for (n1, n2) in ED_

        so_x_ta_x_ed[no_id[n1], no_id[n2]] = true

    end

    so_x_ta_x_ed

end

function play(he_, so_x_ta_x_ed; n_it = 1000, de = 0.5, ch = 0.000001)

    n_no = length(NO_)

    if !(n_no == lastindex(he_) == size(so_x_ta_x_ed, 1) == size(so_x_ta_x_ed, 2))

        error("Numbers of nodes differ.")

    end

    no_x_id_x_he = Matrix{Float64}(undef, n_no, 1 + n_it)

    no_x_id_x_he[:, 1] = he_

    en = enumerate(zip(eachcol(so_x_ta_x_ed), NO_))

    for id in 1:n_it

        id1 = id + 1

        ex = exp((1 - id) * de)

        for (idt, (ed_, at)) in en

            cu = no_x_id_x_he[idt, id]

            if !any(ed_)

                no_x_id_x_he[idt, id1] = cu

                continue

            end

            he_ = no_x_id_x_he[ed_, id]

            me = mean(he_)

            if contains(at, '.')

                if any(iszero, he_)

                    no_x_id_x_he[idt, id1] = 0.0

                    continue

                end

                n_ch = lastindex(at)

                no_x_id_x_he[idt, id1] = view(at, (n_ch - 1):n_ch) == "de" ? -me : me

            else

                no_x_id_x_he[idt, id1] = max(0.0, cu + me * ex)

            end

        end

        if abs(norm(view(no_x_id_x_he, :, id1)) - norm(view(no_x_id_x_he, :, id))) < ch

            return no_x_id_x_he[:, 1:id1]

        elseif id == n_it

            error("Failed to converge.")

        end

    end

end

# TODO: Test.
function play!(no_x_sa_x_he, so_x_ta_x_ed; ke_ar...)

    for (id, he_) in enumerate(eachcol(no_x_sa_x_he))

        no_x_sa_x_he[:, id] = play(he_, so_x_ta_x_ed; ke_ar...)[:, end]

    end

end

function animate(di, el_, no_x_id_x_he; pe = 0, st_ = Dict{String, Any}[])

    n = size(no_x_id_x_he, 2)

    @info "Animating $(Omics.Strin.count(n, "set")) of heat"

    if iszero(pe)

        ch = true

        pe = 1

        st = "change"

    else

        ch = false

        if pe < 1

            pe = round(Int, n * pe)

        end

        st = "every $pe"

    end

    @info "Plotting $st"

    pn_ = String[]

    pr = joinpath(di, randstring())

    for id in 1:n

        tw = !isone(id)

        if tw && !iszero(id % pe) && id != n

            continue

        end

        pri = "$(pr)_$id"

        he_ = no_x_id_x_he[:, id]

        if ch && tw

            he_ .-= view(no_x_id_x_he, :, id - 1)

        end

        plot("$pri.html"; el_, he_, st_, ex = "png")

        push!(pn_, "$pri.png")

    end

    Omics.Plot.animate("$pr.gif", pn_)

end

end
