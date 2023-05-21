using BioLab

# ---- #

if isinteractive()

    ARGS = split(
        "~/craft/data/sex/target_x_sample_x_number.tsv ~/craft/data/sex/feature_x_sample_x_number.tsv 3 3 8 ~/Downloads/match",
    )

end

tst, tsf, n_mas, n_pvs, n_exs, ou = ARGS

tst = expanduser(tst)
@assert isfile(tst)
@show tst

tsf = expanduser(tsf)
@assert isfile(tsf)
@show tsf

n_ma = parse(Int, n_mas)
@show n_ma

n_pv = parse(Int, n_pvs)
@show n_pv

n_ex = parse(Int, n_exs)
@show n_ex

ou = expanduser(ou)
@assert isempty(readdir(ou))
@show ou

# ---- #

_tan, ta_, sa_, ta_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tst))

fen, fe_, _saf_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

@assert sa_ == _saf_

# ---- #

for (ta, nu_) in zip(ta_, eachrow(ta_x_sa_x_nu))

    go_ = [!isnan(nu) for nu in nu_]

    sag_ = sa_[go_]

    nug_ = nu_[go_]

    try

        nug_ = convert(Vector{Int}, nug_)

    catch

    end

    BioLab.Match.make(
        BioLab.Match.cor,
        ta,
        fen,
        fe_,
        sag_,
        nug_,
        fe_x_sa_x_nu[:, go_];
        n_ma,
        n_pv,
        n_ex,
        di = mkpath(joinpath(ou, BioLab.Path.clean("$ta.and.$fen"))),
    )

end
