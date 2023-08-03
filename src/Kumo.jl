module Kumo

using LinearAlgebra: norm

using StatsBase: mean

using BioLab

# TODO: Try not to access the global variables.
# TODO: Consider also using Set.

const NO_ = Vector{String}()

const NO_CL_ = Dict{String, Tuple{Vararg{String}}}()

const ED_ = Vector{Tuple{String, String}}()

# TODO Consider returning.

function _add!(no)

    nos = string(no)

    if nos in NO_

        @warn "$nos exists."

    else

        push!(NO_, nos)

    end

end

function _add!(so::Struct, ta::Struct)

    sos = string(so)

    tas = string(ta)

    ed = (sos, tas)

    if ed in ED_

        @warn "$ed exists."

    else

        for no in ed

            if !(no in NO_)

                error("$no is missing.")

            end

        end

        push!(ED_, ed)

    end

end

function _add!(so_::Tuple, ta::Struct)

    for so in so_

        _add!(so, ta)

    end

end

function _add!(so::Struct, ta_::Tuple)

    for ta in ta_

        _add!(so, ta)

    end

end

function _make_how_node(so::Struct, ho)

    "$so.$ho"

end

function _make_how_node(so_::Tuple, ho)

    _make_how_node(join(so_, '_'), ho)

end

function _add!(so, ho, ta)

    no = _make_how_node(so, ho)

    _add!(no)

    _add!(so, no)

    _add!(no, ta)

end

macro st(sy)

    sy = esc(sy)

    quote

        struct $sy end

        _add!($sy)

    end

end

macro st(sy, cl_...)

    # TODO
    @info "Before" sy
    sy = esc(sy)
    @info "After" sy

    sys = string($sy)

    cls_ = string.($cl_)

    quote

        @st $sy

        NO_CL_[$sys] = $cls_

    end

end

# TODO Consider returning in _add! instead.

function <<(so, ta)

    _add!(so, "de", ta)

    ta

end

function >>(so, ta)

    _add!(so, "in", ta)

    ta

end

function clear!()

    empty!(NO_)

    empty!(NO_CL_)

    empty!(ED_)

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

    @info "Ito" n_no n_cl n_de n_in n_ed

end

function _elementize(no::AbstractString)

    if contains(no, '.')

        cl_ = ("noh", split(no, '.')[2])

    else

        cl_ = ("no", get(NO_CL_, no, ())...)

    end

    Dict("data" => Dict("id" => no, "weight" => 0), "classes" => cl_)

end

function _elementize(tu::Tuple)

    Dict("data" => Dict("source" => tu[1], "target" => tu[2]))

end

function plot(
    ht;
    js = "",
    nos = 24,
    st_ = Vector{Dict{String, Any}}(),
    he_ = Vector{Float64}(),
    hi = 800,
    wi = 800,
    ex = "",
)

    no_ = _elementize.(NO_)

    n_no = length(no_)

    if !isempty(js)

        BioLab.Network.position!(no_, js)

    end

    ed_ = _elementize.(ED_)

    n_ed = length(ed_)

    @info "Plotting" n_no n_ed

    nohs = nos * 0.64

    tri_ = (0.866, 0.5, -0.866, 0.5, 0, -1)

    nod = nos * 0.16

    coe = "#20d9ba"

    st_ = append!(
        [
            Dict(
                "selector" => "node",
                "style" => Dict(
                    "border-width" => 1.6,
                    "border-color" => "#ebf6f7",
                    "font-size" => nos * 0.64,
                ),
            ),
            Dict(
                "selector" => ".no",
                "style" => Dict("height" => nos, "width" => nos, "label" => "data(id)"),
            ),
            Dict(
                "selector" => ".noh",
                "style" => Dict("height" => nohs, "width" => nohs, "shape" => "polygon"),
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
                    "source-distance-from-node" => nod,
                    "target-distance-from-node" => nod,
                    "curve-style" => "bezier",
                    "width" => nos * 0.08,
                    "target-arrow-shape" => "triangle-backcurve",
                    "arrow-scale" => 1.6,
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

        for (no, he, co) in zip(no_, he_, BioLab.Plot.color(he_))

            no["data"]["weight"] = BioLab.String.format(he)

            nos = no["id"]

            push!(st_, Dict("selector" => "#$nos", "style" => Dict("background-color" => co)))

        end

    end

    if !isempty(js)

        la = Dict("name" => "preset")

    elseif 1 < n_ed

        la = Dict(
            "name" => "cose",
            "padding" => 16,
            "boundingBox" => Dict("x1" => 0, "y1" => 0, "h" => hi, "w" => wi),
            "componentSpacing" => 40,
            "nodeRepulsion" => 8000,
            "idealEdgeLength" => 16,
            "numIter" => 10^4,
        )

    else

        la = Dict("name" => "grid")

    end

    BioLab.Network.plot(ht, vcat(no_, ed_); st_, la, ex, he = hi)

end

function animate(gi, js, he___; pe = 1, st_ = Vector{Dict{String, Any}}())

    n = length(he___)

    if iszero(pe)

        @info "Animating changes"

        ch = true

        pe = 1

    else

        @info "Animating every $pe of $n"

        ch = false

        if pe < 1

            pe = ceil(Int, pe * n)

        end

    end

    dw = joinpath(homedir(), "Downloads")

    pr = "animating"

    ke_ = (pr,)

    for pa in BioLab.Path.read(dw; join = true, ke_)

        rm(pa)

    end

    di = dirname(gi)

    for id in 1:n

        if id != 1 && !iszero(id % pe) && id != n

            continue

        end

        he_ = he___[id]

        if ch && 1 < id

            he_ .-= he___[id - 1]

        end

        plot(joinpath(di, "$(pr)_$id.html"); js, st_, he_, ex = "png")

    end

    for pn in BioLab.Path.read(dw; ke_)

        mv(joinpath(dw, pn), joinpath(di, replace(pn, "$(pr)_" => "")))

    end

    BioLab.Plot.animate(
        gi,
        sort(
            BioLab.Path.read(di; join = true, ke_ = (r"png$",));
            by = pa -> parse(Int, chop(basename(pa); tail = 4)),
        ),
    )

end

function make_edge_matrix()

    no_id = Dict(no => id for (id, no) in enumerate(NO_))

    n = length(no_id)

    so_x_ta_x_ed = falses((n, n))

    for (so, ta) in ED_

        so_x_ta_x_ed[no_id[so], no_id[ta]] = true

    end

    so_x_ta_x_ed

end

function heat(no_he; no_pa_ = Dict{String, Tuple}())

    n = length(NO_)

    he_ = zeros(n)

    n_1 = n_2 = 0

    for (id, no) in enumerate(NO_)

        if haskey(no_he, no)

            he = no_he[no]

            @info "$no --> $he."

            he_[id] = he

            n_1 += 1

        elseif haskey(no_pa_, no)

            he2_ = Vector{Float64}()

            for pa in no_pa_[no]

                if haskey(no_he, pa)

                    he2 = no_he[pa]

                    @info "$no --> $pa --> $he2."

                    push!(he2_, he2)

                end

            end

            if isempty(he2_)

                @info "Failed to part-heat $no."

            else

                he = mean(he2_)

                @info "$no --> --> $he."

                he_[id] = he

                n_2 += 1

            end

        else

            @info "Failed to heat $no."

        end

    end

    n_tr = (n - sum(no -> contains(no, '.') || endswith(no, '_'), NO_))

    @info "Heated." n n_tr n_1 n_2 BioLab.String.format((n_1 + n_2) / n_tr * 100)

    he_

end

function heat(fe_, fe_x_sa_x_sc; no_pa_ = Dict{String, Tuple}())

    no_x_sa_x_he = zeros((length(NO_), size(fe_x_sa_x_sc, 2)))

    for (id, sc_) in enumerate(eachcol(fe_x_sa_x_sc))

        no_x_sa_x_he[:, id] = heat(Dict(zip(fe_, sc_)); no_pa_)

    end

    no_x_sa_x_he

end

function _get_norm(he_)

    no = norm(he_)

    @info begin

        println("Norm = $no.")

        id_ = sortperm(he_; rev = true)

        for (he, no) in zip(view(he_, id_), view(NO_, id_))

            if !iszero(he)

                println("$no --> $he.")

            end

        end

        "Last statement."

    end

    no

end

function anneal(he_::AbstractVector, so_x_ta_x_ed; n = 10^3, de = 0.5, ch = 1e-6)

    n_ta = size(so_x_ta_x_ed, 2)

    so___ = eachcol(so_x_ta_x_ed)

    he___ = [he_]

    no = _get_norm(he_)

    for id in 1:n

        ex = exp((1 - id) * de)

        he2_ = Vector{Float64}(undef, n_ta)

        for (idt, (ta, so_)) in enumerate(zip(NO_, so___))

            cu = he_[idt]

            if !any(so_)

                he2_[idt] = cu

                continue

            end

            hes_ = view(he_, so_)

            if contains(ta, '.')

                if any(iszero, hes_)

                    he2_[idt] = 0

                    continue

                end

                n_ch = lenght(ta)

                ho = view(ta, n_ch - 1, n_ch)

                if ho == "de"

                    si = -1

                else#if ho == "in"

                    si = 1

                end

                he2_[idt] = si * mean(hes_)

            else

                he2_[idt] = max(0, cu + mean(hes_) * ex)

            end

        end

        push!(he___, he2_)

        no2 = _get_norm(he2_)

        ch2 = no2 - no

        @info "Δ = $ch2."

        if abs(ch2) < ch

            @info "Converged."

            break

        elseif id == n

            @info "Failed to converge." no2 ch2

        end

        he_ = he2_

        no = no2

    end

    he___

end

function anneal(no_x_sa_x_he::AbstractMatrix, so_x_ta_x_ed; ke_ar...)

    no_x_sa_x_an = similar(no_x_sa_x_he)

    for (id, he_) in enumerate(eachcol(no_x_sa_x_he))

        no_x_sa_x_an[:, id] .= anneal(he_, so_x_ta_x_ed; ke_ar...)[end]

    end

    no_x_sa_x_an

end

end
