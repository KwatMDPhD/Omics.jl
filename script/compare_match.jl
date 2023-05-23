using BioLab

# ---- #

if isinteractive()

    ARGS = split(
        "~/Downloads/match/female.and.gene/feature_x_statistic_x_humber.tsv ~/Downloads/match/random.and.gene/feature_x_statistic_x_humber.tsv ~/Downloads/compare_match",
    )

end

ts1, ts2, ou = ARGS

ts1 = expanduser(ts1)
@assert isfile(ts1)
@show ts1

ts2 = expanduser(ts2)
@assert isfile(ts2)
@show ts2

ou = expanduser(ou)
# @assert isempty(readdir(ou))
@show ou

# ---- #

fen, fe1_, st_, fe_x_st_x_nu1 = BioLab.DataFrame.separate(BioLab.Table.read(ts1))

_fen, fe2_, _st_, fe_x_st_x_nu2 = BioLab.DataFrame.separate(BioLab.Table.read(ts2))

@assert fen == _fen

@assert fe1_ == fe2_

@assert st_ == _st_

nu1_, fe1_ = BioLab.Collection.sort_like((fe_x_st_x_nu1[:, 1], fe1_))

id_ = indexin(fe1_, fe2_)

fe2_ = fe2_[id_]

nu2_ = fe_x_st_x_nu2[id_, 1]

@assert fe1_ == fe2_

# ---- #

op_ = [sqrt(nu1^2 + nu2^2) for (nu1, nu2) in zip(nu1_, nu2_)]

BioLab.Normalization.normalize_with_01!(op_)

# ---- #

na1 = basename(dirname(ts1))

na2 = basename(dirname(ts2))

BioLab.Plot.plot_scatter(
    (nu2_,),
    (nu1_,),
    (fe1_,),
    mode_ = ("markers",),
    marker_color_ = ("#20d9ba",);
    opacity_ = (op_,),
    layout = Dict(
        "title" => Dict("text" => "Comparing Match"),
        "yaxis" => Dict("title" => Dict("text" => na2)),
        "xaxis" => Dict("title" => Dict("text" => na1)),
    ),
    ht = joinpath(ou, "$na1.$na2.html"),
)
