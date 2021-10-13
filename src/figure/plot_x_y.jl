using PlotlyJS: Layout, SyncPlot, scatter

function plot_x_y(
    y_::Vector{Vector{Float64}},
    x_::Vector{Vector{Float64}};
    text_::Vector{Vector{String}} = Vector{Vector{String}}(),
    name_::Vector{String} = Vector{String}(),
    mode_::Vector{String} = Vector{String}(),
    la::Layout = Layout(),
    pa::String = "",
)::SyncPlot

    tr_ = [scatter(;) for ie in 1:length(y_)]

    for (ie, tr) in enumerate(tr_)

        if 0 < length(name_)

            tr["name"] = name_[ie]

        end

        tr["y"] = y_[ie]

        tr["x"] = x_[ie]

        if 0 < length(text_)

            tr["text"] = text_[ie]

        end

        if 0 < length(mode_)

            mode = mode_[ie]

        else

            if length(x_[ie]) < 1000

                mode = "markers+lines"

            else

                mode = "lines"

            end


        end

        tr["mode"] = mode

        tr["opacity"] = 0.8

    end

    return plot(tr_, la; pa = pa)

end

function plot_x_y(y_::Vector{Vector{Float64}}; ke_ar...)::SyncPlot

    return plot_x_y(
        y_,
        [convert(Vector{Float64}, 1:length(y)) for y in y_];
        ke_ar...,
    )

end

export plot_x_y
