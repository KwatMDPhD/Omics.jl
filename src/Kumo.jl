module Kumo

using LinearAlgebra: norm

using StatsBase: mean

using BioLab

const NO_ = Vector{String}()

const NO_CL_ = Dict{String, Tuple}()

const ED_ = Vector{Tuple{String, String}}()

function _add!(no)

    nos = string(no)

    if nos in NO_

        BioLab.check_print(!contains(nos, '.'), "‼️  $nos.")

    else

        push!(NO_, nos)

    end

    return nothing

end

function _add!(so, ta)

    sos = string(so)

    tas = string(ta)

    ed = (sos, tas)

    if !(ed in ED_)

        for no in ed

            if !(no in NO_)

                error("🫥 $no")

            end

        end

        push!(ED_, ed)

    end

    return nothing

end

function _add!(so_::Tuple, ta)

    for so in so_

        _add!(so, ta)

    end

    return nothing

end

function _add!(so, ta_::Tuple)

    for ta in ta_

        _add!(so, ta)

    end

    return nothing

end

function _make_how_node(so, ho)

    return "$so.$ho"

end

function _make_how_node(so_::Tuple, ho)

    return _make_how_node(join(so_, '_'), ho)

end

function _add!(so, ho, ta)

    no = _make_how_node(so, ho)

    _add!(no)

    _add!(so, no)

    _add!(no, ta)

    return nothing

end

macro st(sy)

    sy = esc(sy)

    return quote

        struct $sy end

        _add!($sy)

    end

end

macro st(sy, cl_...)

    sy = esc(sy)

    return quote

        @st $sy

        NO_CL_[string($sy)] = Tuple(string(cl) for cl in $cl_)

    end

end

function <<(so, ta)

    _add!(so, "de", ta)

    return ta

end

function >>(so, ta)

    _add!(so, "in", ta)

    return ta

end

function clear!()

    empty!(NO_)

    empty!(ED_)

    empty!(NO_CL_)

    return nothing

end

function print()

    n_no = length(Kumo.NO_)

    n_cl = length(Kumo.NO_CL_)

    n_de = n_in = 0

    for no in Kumo.NO_

        if endswith(no, ".de")

            n_de += 1

        elseif endswith(no, ".in")

            n_in += 1

        end

    end

    n_ed = length(Kumo.ED_)

    n_pa = 7

    println("🕷️  💬")

    println("🦋 $(rpad(n_no, n_pa)) Nodes")

    println("🐝 $(rpad(n_cl, n_pa))   with classes")

    println("🌚 $(rpad(n_de, n_pa))   decreases potential")

    println("🌝 $(rpad(n_in, n_pa))   increases potential")

    println("🕸️  $(rpad(n_ed, n_pa)) Edges")

    return nothing

end

function _elementize(no::String)

    if contains(no, '.')

        cl_ = ("noh", split(no, '.')[2])

    else

        cl_ = ("no", get(NO_CL_, no, ())...)

    end

    return Dict("data" => Dict("id" => no, "weight" => 0), "classes" => cl_)

end

function _elementize(tu)

    return Dict("data" => Dict("source" => tu[1], "target" => tu[2]))

end

function plot(;
    js = "",
    nos = 24,
    st_ = Vector{Dict{String, Any}}(),
    he_ = Vector{Float64}(),
    hi = 800,
    wi = 800,
    ht = "",
    wr = "",
)

    # TODO: Do not access the global variable.
    # TODO: Is accessing a global variable via default keyword argument as bad?
    no_ = [_elementize(no) for no in NO_]

    n_no = length(no_)

    if !isempty(js)

        BioLab.Network.position!(no_, js)

    end

    # TODO: Do not access the global variable.
    ed_ = [_elementize(ed) for ed in ED_]

    n_ed = length(ed_)

    println(
        "🎨 Plotting $(BioLab.String.count_noun(n_no, "node")) and $(BioLab.String.count_noun(n_ed, "edge"))",
    )

    nohs = nos * 0.64

    tri_ = (0.866, 0.5, -0.866, 0.5, 0.0, -1.0)

    di = nos * 0.16

    coe = "#20d9ba"

    st_ = append!(
        [
            Dict(
                "selector" => "node",
                "style" => Dict(
                    "border-width" => 1.6,
                    "border-color" => "#ebf6f7",
                    "label" => "data(id)",
                    "font-size" => nos * 0.64,
                ),
            ),
            Dict("selector" => ".no", "style" => Dict("height" => nos, "width" => nos)),
            Dict(
                "selector" => ".noh",
                "style" => Dict(
                    "height" => nohs,
                    "width" => nohs,
                    "shape" => "polygon",
                    "label" => "",
                ),
            ),
            Dict(
                "selector" => ".de",
                "style" => Dict(
                    "background-color" => "#ffd96a",
                    "shape-polygon-points" => Tuple(-tr for tr in tri_),
                ),
            ),
            Dict(
                "selector" => ".in",
                "style" =>
                    Dict("background-color" => "#00936e", "shape-polygon-points" => tri_),
            ),
            Dict(
                "selector" => ".nodehover",
                "style" => Dict(
                    "border-style" => "double",
                    "border-color" => coe,
                    "label" => "data(weight)",
                ),
            ),
            Dict(
                "selector" => "edge",
                "style" => Dict(
                    "curve-style" => "bezier",
                    "width" => nos * 0.08,
                    "target-arrow-shape" => "triangle-backcurve",
                    "arrow-scale" => 1.6,
                    "source-distance-from-node" => di,
                    "target-distance-from-node" => di,
                    "line-opacity" => 0.64,
                    "line-fill" => "linear-gradient",
                    "line-gradient-stop-colors" => ("#ffffff", "#171412"),
                    "target-arrow-color" => "#171412",
                ),
            ),
            Dict(
                "selector" => ".edgehover",
                "style" => Dict(
                    "line-opacity" => 1,
                    "line-gradient-stop-colors" => ("#ffffff", coe),
                    "target-arrow-color" => coe,
                ),
            ),
        ],
        st_,
    )

    if !isempty(he_)

        for (no, he) in zip(no_, he_)

            no["data"]["weight"] = BioLab.Number.format(he)

        end

        co = copy(he_)

        BioLab.Normalization.normalize_with_01!(co)

        append!(
            st_,
            (
                Dict(
                    "selector" => "#$no",
                    "style" =>
                        Dict("background-color" => BioLab.Plot.color(BioLab.Plot.COBWR, fr)),
                ) for (no, fr) in zip(NO_, co)
            ),
        )

    end

    if !isempty(js)

        me = Dict("name" => "preset")

    elseif 1 < length(ed_)

        me = Dict(
            "name" => "cose",
            "padding" => 16,
            "boundingBox" => Dict("x1" => 0, "y1" => 0, "h" => hi, "w" => wi),
            "componentSpacing" => 40,
            "nodeRepulsion" => 8000,
            "idealEdgeLength" => 16,
            "numIter" => 10^4,
        )

    else

        me = Dict("name" => "grid")

    end

    BioLab.Network.plot(
        vcat(no_, ed_);
        st_,
        la = merge(me, Dict("animate" => false)),
        ht,
        he = hi,
        wr,
    )

    return nothing

end

function animate(js, he___, di; pe = 1, st_ = Vector{Dict}())

    n = length(he___)

    if pe == 0

        ch = true

        pe = 1

        println("📽️  Animating changes")

    else

        ch = false

        if pe < 1

            pe = ceil(Int, pe * n)

        end

        println("📽️  Animating every $pe of $n")

    end

    dw = joinpath(homedir(), "Downloads")

    pr = "Kumo.animate"

    ke_ = (pr,)

    for pa in BioLab.Path.list(dw; jo = true, ke_)

        rm(pa)

    end

    for id in 1:n

        if !(id == 1 || id % pe == 0 || id == n)

            continue

        end

        pri = "$pr.$id"

        he_ = he___[id]

        if ch && 1 < id

            he_ -= he___[id - 1]

        end

        plot(; js, st_, he_, ht = joinpath(di, "$pri.html"), wr = "png")

        pn = joinpath(dw, "$pri.png")

        while !ispath(pn)

            sleep(0.2)

        end

    end

    for na in BioLab.Path.list(dw; jo = false, ig_ = (r"download$",), ke_)

        BioLab.Path.move(joinpath(dw, na), joinpath(di, replace(na, "$pr." => "")); force = true)

    end

    pn_ = sort(
        BioLab.Path.list(di; jo = true, ke_ = (r"png$",));
        by = pa -> parse(Int, splitext(basename(pa))[1]),
    )

    gi = joinpath(di, "animate.gif")

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

    println("🎞️  $gi.")

    return gi

end

function make_edge_matrix()

    no_id = BioLab.Collection.pair_index(NO_)[1]

    n = length(no_id)

    so_x_ta_x_ed = fill(false, (n, n))

    for (so, ta) in ED_

        so_x_ta_x_ed[no_id[so], no_id[ta]] = true

    end

    return so_x_ta_x_ed

end

function heat(fe_sc; no_al_ = Dict{String, Tuple}(), pr = true)

    he_ = fill(0.0, length(NO_))

    n_tr = 0

    n_ex = 0

    n_al = 0

    for (id, no) in enumerate(NO_)

        if contains(no, '.') || endswith(no, '_')

            continue

        end

        n_tr += 1

        if haskey(fe_sc, no)

            he_[id] = fe_sc[no]

            n_ex += 1

        elseif haskey(no_al_, no)

            hea_ = Vector{Float64}()

            for al in no_al_[no]

                if haskey(fe_sc, al)

                    he = fe_sc[al]

                    BioLab.check_print(pr, "$no 📛 $al 👉 $he")

                    push!(hea_, he)

                end

            end

            if !isempty(hea_)

                he = mean(hea_)

                BioLab.check_print(pr, "$no 🔱 $he")

                he_[id] = he

                n_al += 1

            end

        end

    end

    for (st, nu) in (
        ("🤞 Tried", n_tr),
        ("📇 Exactly heated", n_ex),
        ("📛 Alias heated", n_al),
        ("🔥 Succeeded (%)", (n_ex + n_al) / n_tr * 100),
    )

        BioLab.check_print(pr, "$(rpad(st, 23)) $nu.")

    end

    return he_

end

function heat(fe_, fe_x_sa_x_sc; no_al_ = Dict{String, Tuple}())

    no_x_sa_x_he = fill(0.0, length(NO_), size(fe_x_sa_x_sc, 2))

    for (id, sc_) in enumerate(eachcol(fe_x_sa_x_sc))

        no_x_sa_x_he[:, id] = heat(Dict(zip(fe_, sc_)); no_al_, pr = id == 1)

    end

    return no_x_sa_x_he

end

function _get_norm(he_, pr)

    no = norm(he_)

    BioLab.check_print(pr, "🧮 $(BioLab.Number.format(no)).")

    if pr

        n = maximum(length(no) for no in NO_) + 2

        for (he, no) in zip(BioLab.Collection.sort_like((he_, NO_); ic = false)...)

            BioLab.check_print(he != 0.0, "  $(rpad(no, n))$(BioLab.Number.format(he)).")

        end

    end

    return no

end

function anneal(
    he_::AbstractVector{<:Real},
    so_x_ta_x_ed = make_edge_matrix();
    n = 10^3,
    de = 0.5,
    ch = 10^-6,
    pr = true,
)

    n_ta = size(so_x_ta_x_ed, 2)

    so___ = eachcol(so_x_ta_x_ed)

    he___ = [he_]

    no = _get_norm(he_, pr)

    for id in 1:n

        ex = exp((1 - id) * de)

        he2_ = Vector{Float64}(undef, n_ta)

        for (idt, (ta, so_)) in enumerate(zip(NO_, so___))

            cu = he_[idt]

            if !any(so_)

                he2_[idt] = cu

                continue

            end

            hes_ = he_[so_]

            if contains(ta, '.')

                if any(he == 0.0 for he in hes_)

                    he2_[idt] = 0.0

                    continue

                end

                ho = split(ta, '.')[2]

                if ho == "de"

                    he2_[idt] = -mean(hes_)

                elseif ho == "in"

                    he2_[idt] = mean(hes_)

                else

                    error()

                end

            else

                he2_[idt] = max(0.0, cu + mean(hes_) * ex)

            end

        end

        push!(he___, he2_)

        no2 = _get_norm(he2_, pr)

        ch2 = no2 - no

        BioLab.check_print(pr, "  🐣 $(BioLab.Number.format(ch2)).")

        if abs(ch2) < ch

            BioLab.check_print(pr, "🏁 $id / $n.")

            break

        elseif id == n

            @warn "👺 Did not converge." no2 ch2

        end

        he_ = he2_

        no = no2

    end

    return he___

end

# TODO: Test multiple dispatch.
function anneal(no_x_sa_x_he, so_x_ta_x_ed = make_edge_matrix(); ke_ar...)

    no_x_sa_x_an = Matrix{Float64}(undef, size(no_x_sa_x_he))

    for (id, he_) in enumerate(eachcol(no_x_sa_x_he))

        no_x_sa_x_an[:, id] = anneal(convert(Vector{Float64}, he_), so_x_ta_x_ed; ke_ar...)[end]

    end

    return no_x_sa_x_an

end

end
