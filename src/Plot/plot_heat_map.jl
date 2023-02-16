function _fractionate(co)

    return collect(zip(0.0:(1 / (length(co) - 1)):1.0, "#$(hex(rg))" for rg in co))

end

function plot_heat_map(
    z::AbstractMatrix,
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)];
    nar = "Row",
    nac = "Column",
    colorscale = _fractionate(COPL),
    grr_ = [],
    grc_ = [],
    layout = Dict{String, Any}(),
    ht = "",
)

    n_ro, n_co = size(z)

    axis = Dict("domain" => (0.0, 0.95), "automargin" => true)

    axis2 = Dict("domain" => (0.96, 1.0), "tickvals" => ())

    layout = BioLab.Dict.merge(
        Dict(
            "title" => Dict("text" => "Heat Map"),
            "yaxis" =>
                BioLab.Dict.merge(axis, Dict("title" => Dict("text" => "$nar (n=$n_ro)"))),
            "xaxis" =>
                BioLab.Dict.merge(axis, Dict("title" => Dict("text" => "$nac (n=$n_co)"))),
            "yaxis2" => axis2,
            "xaxis2" => axis2,
        ),
        layout,
        BioLab.Dict.set_with_last!,
    )

    data = []

    # TODO: Cluster within a group.

    if !isempty(grr_)

        if eltype(grr_) <: AbstractString

            gr_id = BioLab.Vector.pair_index(unique(grr_))[1]

            grr_ = [gr_id[gr] for gr in grr_]

        end

        so_ = sortperm(grr_)

        grr_ = grr_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(grc_)

        if eltype(grc_) <: AbstractString

            gr_id = BioLab.Vector.pair_index(unique(grc_))[1]

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = grc_[so_]

        x = x[so_]

        z = z[:, so_]

    end

    fl_ = n_ro:-1:1

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "z" => collect(eachrow(z))[fl_],
            "y" => y[fl_],
            "x" => x,
            "colorscale" => colorscale,
            "colorbar" => Dict("x" => 1.05),
        ),
    )

    trace = Dict(
        "type" => "heatmap",
        "colorscale" => _fractionate(COPO),
        "colorbar" => Dict("x" => 1.15, "dtick" => 1.0),
    )

    if !isempty(grr_)

        push!(
            data,
            BioLab.Dict.merge(
                trace,
                Dict("xaxis" => "x2", "z" => [[grr] for grr in grr_][fl_], "hoverinfo" => "z+y"),
                BioLab.Dict.set_with_last!,
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            BioLab.Dict.merge(
                trace,
                Dict("yaxis" => "y2", "z" => [grc_], "hoverinfo" => "z+x"),
                BioLab.Dict.set_with_last!,
            ),
        )

    end

    return plot(data, layout; ht = ht)

end

function plot_heat_map(ro_x_co_x_nu; ke_ar...)

    ro, ro_, co_, ro_x_co_x_nu = BioLab.DataFrame.separate(ro_x_co_x_nu)

    return plot_heat_map(ro_x_co_x_nu, ro_, co_; nar = ro, ke_ar...)

end
