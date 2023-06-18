module PatternMatch

using Comonicon: @cast, @main

using BioLab

function match(tst, tsf, n_mas, n_pvs, n_exs, ou)

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

    _tan, ta_, sa_, ta_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tst))

    fen, fe_, _saf_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

    @assert sa_ == _saf_

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

end

function compare_match(ts1, ts2, ou)

    ts1 = expanduser(ts1)
    @assert isfile(ts1)
    @show ts1

    ts2 = expanduser(ts2)
    @assert isfile(ts2)
    @show ts2

    ou = expanduser(ou)
    # @assert isempty(readdir(ou))
    @show ou

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

    op_ = [sqrt(nu1^2 + nu2^2) for (nu1, nu2) in zip(nu1_, nu2_)]

    BioLab.NumberArray.normalize_with_01!(op_)

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

end

end
