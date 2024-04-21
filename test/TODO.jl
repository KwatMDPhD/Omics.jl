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

const DS_ = ("GSE24759", "GSE107011")#sort!(unique(DA_))

const ID___ = Tuple(DA_ .== ds for ds in DS_)

# ---- #

const MA_ = [FS[:, id_] for id_ in ID___]

const x = vcat((SA_[id_] for id_ in ID___)...)

const gc_ = vcat((DA_[id_] for id_ in ID___)...)

const wi = lastindex(x) * 8

# ---- #

const ID_ = findall(!allequal, eachrow(hcat(MA_...)))

for (id, ma) in enumerate(MA_)

    MA_[id] = ma[ID_, :]

end

# ---- #

const UF = 8

const TO = 1e-6

const UI = 10^4

# ---- #

seed!(20240420)

const TW, TH = Nucleus.MatrixFactorization.factorize(
    hcat(MA_...),
    UF;
    init = :random,
    alg = :multmse,
    tol = TO,
    maxiter = UI,
)

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "st.html"), TH; x, gc_, wi)

# ---- #

seed!(20240420)

const IW_, IH_, NO___ = Nucleus.MatrixFactorization.factorize_wide(MA_, UF, TO, UI)

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "si.html"), hcat(IH_...); x, gc_, wi)
