function plot(
    ro_x_fa_x_po_,
    fa_x_co_x_po_;
    nar_ = ["Rows $id" for id in 1:length(ro_x_fa_x_po_)],
    nac_ = ["Columns $id" for id in 1:length(fa_x_co_x_po_)],
    naf = "Factor",
    ro__ = (
        ["$na $id" for id in 1:size(ro_x_fa_x_po, 1)] for
        (ro_x_fa_x_po, na) in zip(ro_x_fa_x_po_, nar_)
    ),
    co__ = (
        ["$na $id" for id in 1:size(fa_x_co_x_po, 2)] for
        (fa_x_co_x_po, na) in zip(fa_x_co_x_po_, nac_)
    ),
    di = "",
)

    #
    fa_ = ["$naf $id" for id in 1:size(ro_x_fa_x_po_[1], 2)]

    #
    lo = 800

    sh = lo / MathConstants.golden

    axis = Dict("dtick" => 1.0)

    #
    for (id, (ro_x_fa_x_po, ro_, nar)) in enumerate(zip(ro_x_fa_x_po_, ro__, nar_))

        #
        title_text = "row$(id)_x_factor_x_positive"

        #
        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            BioLab.Table.write(
                joinpath(di, "$title_text.tsv"),
                BioLab.DataFrame.make(nar, ro_, fa_, ro_x_fa_x_po),
            )

        end

        #
        or_ = BioLab.Clustering.hierarchize(ro_x_fa_x_po).order

        BioLab.Plot.plot_heat_map(
            BioLab.Normalization.normalize(ro_x_fa_x_po[or_, :], 1, "-0-"),
            ro_[or_],
            fa_,
            nar = nar,
            nac = naf,
            layout = Dict(
                "height" => lo,
                "width" => sh,
                "title" =>
                    Dict("text" => BioLab.String.title(replace(title_text, "_x_" => "_by_"))),
                "xaxis" => axis,
            ),
            ht = ht,
        )

    end

    #
    for (id, (fa_x_co_x_po, co_, nac)) in enumerate(zip(fa_x_co_x_po_, co__, nac_))

        #
        title_text = "factor_x_column$(id)_x_positive"

        #
        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            BioLab.Table.write(
                joinpath(di, "$title_text.tsv"),
                BioLab.DataFrame.make(naf, fa_, co_, fa_x_co_x_po),
            )

        end

        #
        or_ = BioLab.Clustering.hierarchize(transpose(fa_x_co_x_po)).order

        BioLab.Plot.plot_heat_map(
            BioLab.Normalization.normalize(fa_x_co_x_po[:, or_], 2, "-0-"),
            fa_,
            co_[or_],
            nar = naf,
            nac = nac,
            layout = Dict(
                "height" => sh,
                "width" => lo,
                "title" =>
                    Dict("text" => BioLab.String.title(replace(title_text, "_x_" => "_by_"))),
                "yaxis" => axis,
            ),
            ht = ht,
        )

    end

    nothing

end
