using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

const NS = "Cells"

# ---- #

const _NI, _IR_, SA_, IS =
    Nucleus.DataFrame.separate("../../../pro/Data.pro/output/combine/information_x_cell_x_any.tsv")

# ---- #

const NF, FE_, _SF_, FS =
    Nucleus.DataFrame.separate("../../../pro/Data.pro/output/combine/common_x_cell_x_number.tsv")

# ---- #

const DA_ = IS[1, :]

const TI_ = IS[8, :]

SA_ .= ("$(replace(da, "GSE" => "")) $ti $id" for (id, (da, ti)) in enumerate(zip(DA_, TI_)))

# ---- #

foreach(Nucleus.Normalization.normalize_with_125254!, eachcol(FS))

foreach(Nucleus.Normalization.normalize_with_01!, eachcol(FS))

@assert all(>=(0), FS)

# ---- #

println(Nucleus.Collection.count_sort_string(DA_))

const DS_ = sort!(unique(DA_))

const ID___ = Tuple(DA_ .== ds for ds in DS_)

# ---- #

const MA_ = [FS[:, id_] for id_ in ID___]

const x = vcat((SA_[id_] for id_ in ID___)...)

const gc_ = vcat((DA_[id_] for id_ in ID___)...)

# ---- #

function plot(ht, z)

    id_ = Nucleus.Clustering.hierarchize(Nucleus.Distance.IN, eachcol(z)).order

    Nucleus.Plot.plot_heat_map(
        ht,
        z[:, id_];
        x = x[id_],
        wi = lastindex(x) * 16,
        layout = Dict("xaxis" => Dict("dtick" => 1)),
    )

end

# ---- #

const ID_ = findall(!allequal, eachrow(hcat(MA_...)))

for (id, ma) in enumerate(MA_)

    MA_[id] = ma[ID_, :]

end

# ---- #

const UF = 8

const TO = 1e-3

const UI = 10^3

seed!(20240420)

# ---- #

const TW, TH = Nucleus.MatrixFactorization.factorize(
    hcat(MA_...),
    UF;
    init = :random,
    alg = :multmse,
    tol = TO,
    maxiter = UI,
)

plot(joinpath(Nucleus.TE, "st.html"), TH)

# ---- #

const IW_, IH_, AI = Nucleus.MatrixFactorization.factorize_wide(MA_, UF, TO, UI)

plot(joinpath(Nucleus.TE, "si.html"), hcat(IH_...))
