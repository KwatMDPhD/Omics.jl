module Density

# TODO: https://github.com/panlanfeng/KernelEstimator.jl/blob/master/src/bandwidth.jl.
using KernelDensity: default_bandwidth, kde

using ..Nucleus

function get_bandwidth(nu_)

    default_bandwidth(nu_)

end

function estimate(nu___; ke_ar...)

    de = kde(nu___; ke_ar...)

    de.x, de.y, de.density

end

function plot(ht, ro_, co_, de; title_text = "Density")

    @info "Density" ro_ co_ de

    Nucleus.Plot.plot_heat_map(
        ht,
        de;
        y = Nucleus.Plot._label_row.(Nucleus.Number.format4.(ro_)),
        x = Nucleus.Plot._label_col.(Nucleus.Number.format4.(co_)),
        layout = Dict(
            "title" => Dict("text" => title_text),
            "yaxis" => Dict("title" => Dict("text" => "← <b>$(lastindex(ro_))</b>")),
            "xaxis" => Dict("title" => Dict("text" => "<b>$(lastindex(co_))</b> →")),
        ),
    )

end

end
