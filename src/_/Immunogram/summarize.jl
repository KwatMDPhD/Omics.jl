include("_.jl")

# ---- #

println("🚦")

st = ARGS[1]
@show st

su = ARGS[2]
@show su

# ---- #

ou = make_output_directory(@__FILE__, st, su)

# ---- #

name_ = ("Feature", NAH, NAA, NAS)

marker_color_ = (COF, COH, COA, COS)

# ---- #

it_ = Vector{String}()

su___ = Vector{Vector{Float64}}()

for na in readdir(OU)

    if !(startswith(na, st) && contains(na, su))

        continue

    end

    push!(it_, na)

    na_sc = BioLab.Dict.read(joinpath(OU, na, "summary.json"))

    push!(su___, [na_sc[na] for na in name_])

end

# ---- #

id_ = sortperm(it_; by = it -> (contains(it, "ImmuneSystem"), it))

it_ = it_[id_]

su___ = su___[id_]

# ---- #

if st == "cluster"

    title_text = "Clustering Summary"

    yaxis_title_text = "Tight %"

elseif st == "match"

    title_text = "Matching Summary"

    yaxis_title_text = "Correlation Magnitude"

end

BioLab.Plot.plot_bar(
    [[su_[id] for su_ in su___] for id in eachindex(name_)],
    fill(it_, length(name_));
    name_,
    marker_color_,
    layout = Dict(
        "barmode" => "",
        "title" => Dict("text" => title_text),
        "yaxis" => Dict("title" => Dict("text" => yaxis_title_text)),
        "xaxis" => Dict("title" => Dict("text" => "Ito")),
    ),
    ht = joinpath(ou, "summary.html"),
)
