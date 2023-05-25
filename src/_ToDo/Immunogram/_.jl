const DO = joinpath(homedir(), "Downloads")

const PK = dirname(@__DIR__)

const IN = joinpath(PK, "input")

const OU = joinpath(PK, "output")

# ----------------------------------------------------------------------------------------------- #

using DataFrames

using OrderedCollections

using ProgressMeter

using Random

using StatsBase

using Test

using BioLab

using Kumo: Kumo, @st, <<, >>

using ImmuneSystem

# ---- #

function parse_args()

    println("🚦")

    it = ARGS[1]
    @show it

    as = parse(Bool, ARGS[2])
    @show as

    de = parse(Float64, ARGS[3])
    @show de

    pe = parse(Float64, ARGS[4])
    @show pe

    bo = parse(Bool, ARGS[5])
    @show bo

    da = ARGS[6]
    @show da

    ke_va = BioLab.Dict.read(da)

    nas = ke_va["nas"]
    @show nas

    los_::Vector{String} = ke_va["los_"]
    @show los_

    tsi = ke_va["tsi"]
    @show tsi

    iop = ke_va["iop"]
    @show iop

    tsf = ke_va["tsf"]
    @show tsf

    lof_::Vector{String} = ke_va["lof_"]
    @show lof_

    return it, as, de, pe, bo, da, nas, los_, tsi, iop, tsf, lof_

end

# ---- #

function make_output_directory(jl, ar_...)

    pr = splitext(basename(jl))[1]

    ou = joinpath(OU, join((pr, ar_...), '.'))

    BioLab.Path.empty(ou)

    return ou

end

# ---- #

const ST_ = Vector{Dict{String, Any}}()

for (se, ke_va) in Dict(
    #
    "mo" => Dict("style" => Dict("background-color" => "#985629"), "si" => 16),
    "pr" => Dict("style" => Dict("background-color" => "#181b26"), "si" => 16),
    "ch" => Dict("style" => Dict("background-color" => "#8db255"), "si" => 16),
    "me" => Dict("style" => Dict("background-color" => "#b64925"), "si" => 16),
    #
    "re" => Dict("style" => Dict("background-color" => "#006c7f"), "si" => 24),
    "ad" => Dict("style" => Dict("background-color" => "#ffa400"), "si" => 24),
    "ig" => Dict("style" => Dict("background-color" => "#4e40d8"), "si" => 24),
    #
    "ca" => Dict("style" => Dict("background-color" => "#1f4788"), "si" => 32),
    #
    "ce" => Dict("style" => Dict("background-color" => "#23191e"), "si" => 40),
    "rd" => Dict("style" => Dict("background-color" => "#c91f37"), "si" => 40),
    "pl" => Dict("style" => Dict("background-color" => "#fcc9b9"), "si" => 40),
    "gr" => Dict("style" => Dict("background-color" => "#ff4e20"), "si" => 40),
    "mn" => Dict("style" => Dict("background-color" => "#ff1968"), "si" => 40),
    "na" => Dict("style" => Dict("background-color" => "#006442"), "si" => 40),
    "tc" => Dict("style" => Dict("background-color" => "#20d9ba"), "si" => 40),
    "bc" => Dict("style" => Dict("background-color" => "#9017e6"), "si" => 40),
)

    si = ke_va["si"]

    push!(
        ST_,
        Dict(
            "selector" => ".$se",
            "style" => merge(ke_va["style"], Dict("height" => si, "width" => si)),
        ),
    )

end

# ---- #

function include_ito(it; ou = "", ke_ar...)

    Kumo.clear!()

    # TODO: Multiple dispatch.

    if it == "ImmuneSystem"

        ImmuneSystem.@include

        # TODO: Get from `ImmuneSystem`.
        js = ""

    else

        di = joinpath(IN, "ito")

        include(joinpath(di, "$it.jl"))

        js = joinpath(di, "$it.json")

        Kumo.print()

    end

    wr = "png"

    if ou != ""

        Kumo.plot(; js, st_ = ST_, ht = joinpath(ou, "$it.html"), wr, ke_ar...)

        dw = joinpath(DO, "$it.$wr")

        while !ispath(dw)

            sleep(0.2)

        end

        BioLab.Path.move(dw, replace(dw, DO => ou); force = true)

    end

    return js

end

# ---- #

function look(nu_)

    BioLab.Plot.plot_histogram((nu_,))

    println("🩻")

    describe(nu_)

    return nothing

end

# ---- #

const NAF = "Feature"

const COF = "#2b3736"

const NAN = "Node"

const NAH = "$NAN (Heated)"

const COH = "#ff1968"

const NAA = "$NAN (Heated-Annealed)"

const COA = "#20d9ba"

const NAS = "$NAN (Heated-Shuffled-Annealed)"

const COS = "#2a603b"

# ---- #

# TODO: Decouple reporting.
function alias_and_report(fe_)

    no_ma_ =
        convert(Dict{String, Vector{String}}, BioLab.Dict.read(joinpath(IN, "node_genes.json")))

    pr_ke_va = BioLab.Gene.map_uniprot()

    # TODO: Try `Set`.
    no_al_ = Dict{String, Vector{String}}()

    for no in Kumo.NO_

        if contains(no, '.')

            continue

        end

        BioLab.print_header(no)

        al_ = Vector{String}()

        if haskey(no_ma_, no)

            ma_ = no_ma_[no]

            append!(al_, ma_)

            println("💪 $(join(ma_, " | "))")

        end

        for al in (no, al_...)

            if haskey(pr_ke_va, al)

                ke_va = pr_ke_va[al]

                ge_ = ke_va["Gene Names"]

                append!(al_, ge_)

                println("🦾 $(join(ge_, " | "))")

                ca = ke_va["Caution"]

                if !ismissing(ca)

                    @warn ca

                end

            end

        end

        unique!(al_)

        println("📛 $(length(al_))")

        no_al_[no] = al_

        for fe in fe_

            fel = lowercase(fe)

            for al in al_

                all = lowercase(al)

                if fel == all

                    println("🎣 $fe")

                elseif contains(fel, all)

                    println("🍥 $fe")

                end

            end

        end

    end

    return no_al_

end

# ---- #

function heat(fe_, fe_x_sa_x_nu, fu)

    no_al_ = alias_and_report(fe_)

    no_x_sa_x_he = Kumo.heat(fe_, fe_x_sa_x_nu; no_al_)

    for (id, no) in enumerate(Kumo.NO_)

        if fu(no)

            println("🪵 $no")

            no_x_sa_x_he[id, :] .= 1.0

        end

    end

    return no_x_sa_x_he

end

# ---- #

function is_cell(no)

    if !haskey(Kumo.NO_CL_, no)

        return false

    end

    cl_ = Kumo.NO_CL_[no]

    return !("noh" in cl_) &&
           any(ce in cl_ for ce in ("ce", "rd", "pl", "gr", "mn", "na", "tc", "bc"))

end

# ---- #

function compare_grouping(
    fe_x_sa_x_nu,
    la_,
    fu,
    n_ = 2:length(Set(la_));
    pl = true,
    na = "Feature",
    ou = "",
)

    lau_ = unique(la_)

    n_x_la_x_ti = Matrix{Int}(undef, (length(n_), length(lau_)))

    hi = BioLab.Clustering.hierarchize(fe_x_sa_x_nu, 2; fu)

    for (id, n) in enumerate(n_)

        la_gr_ = Dict(la => Vector{Int}() for la in lau_)

        for (la, gr) in zip(la_, BioLab.Clustering.cluster(hi, n))

            push!(la_gr_[la], gr)

        end

        n_x_la_x_ti[id, :] = [Int(length(Set(la_gr_[la])) == 1) for la in lau_]

    end

    sc = sum(n_x_la_x_ti) / length(n_x_la_x_ti)

    if pl

        so_ = sortperm([sum(co) for co in eachcol(n_x_la_x_ti)])

        if isempty(ou)

            ht = ""

        else

            ht = joinpath(ou, "grouping.$na.html")

        end

        BioLab.Plot.plot_heat_map(
            view(n_x_la_x_ti, :, so_),
            n_,
            lau_[so_];
            nar = "Number of Groups",
            nac = "Labels",
            colorscale = BioLab.Plot.fractionate(BioLab.Plot.COASP),
            layout = Dict(
                "title" =>
                    Dict("text" => "$(BioLab.Number.format(sc * 100))% Tight Grouping Using $na"),
                "yaxis" => Dict("dtick" => 1),
            ),
            ht,
        )

    end

    return sc

end

# ---- #

function make_ta_x_sa_x_nu(an_)

    an_ = [BioLab.String.try_parse(an) for an in an_]

    ty = eltype(an_)

    if ty <: Real

        tan_ = [iop]

        ta_x_sa_x_nu = convert(Matrix{Float64}, reshape(an_, 1, :))

    elseif ty <: AbstractString

        tan_ = sort(unique(an_))

        ta_x_sa_x_nu = fill(0, (length(tan_), length(an_)))

        na_id = Dict(na => id for (id, na) in enumerate(tan_))

        for (id, an) in enumerate(an_)

            ta_x_sa_x_nu[na_id[an], id] = 1

        end

    else

        error(ty)

    end

    return tan_, ta_x_sa_x_nu

end

# ---- #

function average_match_score(feature_x_statistics_x_number)

    return mean((sc for sc in feature_x_statistics_x_number[!, 2] if !isnan(sc)))
end
