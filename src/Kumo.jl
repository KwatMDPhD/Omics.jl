module Kumo

using LinearAlgebra: norm

using OrderedCollections: OrderedSet

using StatsBase: mean

using ..Omics

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

function _make_how_node(an, ho)

    "$an.$ho"

end

function _make_how_node(an_::Tuple, ho)

    _make_how_node(join(an_, '_'), ho)

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

    tr_ = 0.866, 0.5, -0.866, 0.5, 0, -1

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
                        "shape-polygon-points" => map(co -> -co, tr_),
                        "background-color" => Omics.Color.AY,
                    ),
                ),
                Dict(
                    "selector" => ".in",
                    "style" => Dict(
                        "shape-polygon-points" => tr_,
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

function heat(fe_, sc_, no_al_ = Dict{String, Vector{String}}())

    fe_id = Dict(fe => id for (id, fe) in enumerate(fe_))

    u1 = u2 = 0

    he_ = zeros(length(NO_))

    for id in eachindex(NO_)

        no = NO_[id]

        if contains(no, '.')

            continue

        end

        if haskey(fe_id, no)

            u1 += 1

            he_[id] = sc_[fe_id[no]]

        else

            u2 += 1

            ua = su = 0

            for al in no_al_[no]

                if haskey(fe_id, al)

                    ua += 1

                    su += sc_[fe_id[al]]

                end

            end

            if !iszero(su)

                he_[id] = su / ua

            end

        end

    end

    he_

end

function make_edge_matrix()

    un = length(NO_)

    li = falses(un, un)

    no_id = Dict(no => id for (id, no) in enumerate(NO_))

    for (n1, n2) in ED_

        li[no_id[n1], no_id[n2]] = true

    end

    li

end

function play(he_, li; ni = 1000, de = 0.5, ch = 0.000001)

    hi = Matrix{Float64}(undef, length(NO_), 1 + ni)

    hi[:, 1] = he_

    for ii in 1:ni

        i1 = ii + 1

        ex = exp((1 - ii) * de)

        for (io, (li_, no)) in enumerate(zip(eachcol(li), NO_))

            cu = hi[io, ii]

            if !any(li_)

                hi[io, i1] = cu

                continue

            end

            he_ = hi[li_, ii]

            me = mean(he_)

            if contains(no, '.')

                if any(iszero, he_)

                    hi[io, i1] = 0.0

                    continue

                end

                hi[io, i1] = no[(end - 1):end] == "de" ? -me : me

            else

                hi[io, i1] = max(0.0, cu + me * ex)

            end

        end

        if abs(norm(view(hi, :, i1)) - norm(view(hi, :, ii))) < ch

            return hi[:, 1:i1]

        elseif ii == ni

            error("failed to converge.")

        end

    end

end

function animate(pr, ep_, hi; pe = 0, st_ = Dict{String, Any}[])

    ui = size(hi, 2)

    if iszero(pe)

        ch = true

        pe = 1

    else

        ch = false

        if pe < 1

            pe = round(Int, ui * pe)

        end

    end

    pn_ = String[]

    for ii in 1:ui

        go = !isone(ii)

        if !(isone(ii) || iszero(ii % pe) || ii == ui)

            continue

        end

        p2 = "$(pr)_$ii"

        he_ = hi[:, ii]

        if ch && go

            he_ -= view(hi, :, ii - 1)

        end

        plot("$p2.html"; ep_, he_, st_, ex = "png")

        push!(pn_, "$p2.png")

    end

    Omics.Plot.animate("$pr.gif", pn_)

end

end
